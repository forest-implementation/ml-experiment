# frozen_string_literal: true

require "bundler/setup"

require "ml/experiment/preprocessor"
require "ml/forest"
require "ml/service/isolation/outlier"
require "ml/service/isolation/novelty"
require "stats/statistics"
require "plotting/gnuplotter"
require "plotting/preprocessor"

include Plotting::Gnuplotter
include Plotting::Preprocessor
include Stats::Statistics

pp input = [
  [12.6, 3.2],
  [22.3, 6.55],
  [21.4, 2.35],
  [22.45, 5.45],
  [17.8, 5.8],
  [13.05, 3.45],
  [23.55, 4.9],
  [16.75, 5.1],
  [17.7, 3.8],
  [18.45, 5.6],
  [19.9, 3.05],
  [16.5, 5.05],
  [19.95, 5.25],
  [20.9, 6.05],
  [14.45, 5.2],
  [21.1, 3.25],
  [19.65, 6.0],
  [16.4, 3.75],
  [22.35, 3.45],
  [21.2, 4.45],
  [15.65, 5.8],
  [20.05, 6.75],
  [20.5, 3.9],
  [14.5, 3.75],
  [15.95, 6.3],
  [20.25, 4.85],
  [19.1, 4.65],
  [15.85, 3.95],
  [21.05, 4.55],
  [11.6, 4.15]
]
pp
pp ranges = input[0].length.times.map { |x| adjusted_box(input, x) }

novelty_service = Ml::Service::Isolation::Novelty.new(batch_size: 30, max_depth: 5, ranges: ranges)

# FILTER OUT inputs out of range!
inputx = input.map { |input| input[0] }.filter { |input| ranges[0].include?(input) }
inputy = input.map { |input| input[1] }.filter { |input| ranges[1].include?(input) }
input = inputx.zip(inputy)

forest = Ml::Forest::Tree.new(input, trees_count: 1, forest_helper: novelty_service)

points_to_predict = [[15, 2.5], [8, 7], [5, 2.1], [4.5, 2.2], [4.8, 2.0]]
pred_input = input.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }
pred_to_predict = points_to_predict.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }

input_novelty = input.zip(pred_input).filter { |_coord, score| score.novelty? }.map { |x| x[0] }

input_regular = input.zip(pred_input).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }

to_predict_novelty = points_to_predict.zip(pred_to_predict).filter { |_coord, score| score.novelty? }.map { |x| x[0] }
to_predict_regular = points_to_predict.zip(pred_to_predict).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }

def split_and_depths(key, tree, &fun)
  return fun.call [key, tree.data.depth] if tree.is_a?(Node::OutNode)

  tree.branches.map { |key, x| split_and_depths(key, x) { |x| fun.call x } }
end

s = Enumerator.new do |y|
  split_and_depths(ranges, forest.trees[0]) { |x| y << x }
end

def prepare_depth_labels(split_depths_array)
  split_depths_array.map do |ranges, depth|
    x = ranges[0].minmax.sum / 2.0
    y = ranges[1].minmax.sum / 2.0
    [depth, x, y]
  end
end

labels, label_xs, label_ys = prepare_depth_labels(s).transpose
line_xs, line_ys = prepare_lines(ranges, forest)

plot_regular = input_regular + to_predict_regular
plot_novelty = input_novelty + to_predict_novelty

plot("../../figures/example1_gnu.svg", ranges[0].minmax, ranges[1].minmax) do |plot|
  plot.data << points_init(*plot_regular.transpose, "regular") # regular
  plot.data << points_init(*plot_novelty.transpose, "novelty") # novelty
  plot.data << lines_init(prepare_for_lines_plot(line_xs), prepare_for_lines_plot(line_ys))
  set_labels(plot, %w[Px B], [15 - 1, 7], [2.5 + 0.1, 7], style="Bold")
  set_labels(plot, labels, label_xs, label_ys)
end
