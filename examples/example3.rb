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

input = [
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

pp ranges = input[0].length.times.map { |dim| adjusted_box(input, dim) }
ranges = [0..30, 0..10]
novelty_service = Ml::Service::Isolation::Novelty.new(batch_size: input.size, max_depth: 5, ranges: ranges)

points_to_predict = [[29, 5]]
input += points_to_predict
# FILTER OUT inputs out of range!
input = input.filter { |input| ranges[0].include?(input[0]) && ranges[1].include?(input[1]) }
points_to_predict = points_to_predict.filter { |input| ranges[0].include?(input[0]) && ranges[1].include?(input[1]) }

# cerny kdyz ucis s nim
# muzes zakomentovat a bude modry

# points_to_predict = [[10, 5]]
# input += points_to_predict
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: novelty_service)

pred_input = input.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }
pred_to_predict = points_to_predict.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }

input_novelty = input.zip(pred_input).filter { |_coord, score| score.novelty? }.map { |x| x[0] }

pp input_novelty.size

input_regular = input.zip(pred_input).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }

to_predict_novelty = points_to_predict.zip(pred_to_predict).filter { |_coord, score| score.novelty? }.map { |x| x[0] }
to_predict_regular = points_to_predict.zip(pred_to_predict).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }

pp to_predict_novelty.size

Gnuplot.open do |gp|
  s = Enumerator.new do |y|
    split_and_depths(ranges, forest.trees[0]) { |x| y << x }
  end

  labels, label_xs, label_ys = prepare_depth_labels(s).transpose
  line_xs, line_ys = prepare_lines(ranges, forest)

  plot_regular = input_regular + to_predict_regular
  plot_novelty = input_novelty + to_predict_novelty

  plot(gp, "../../figures/example3_gnu.svg", ranges[0].minmax, ranges[1].minmax) do |plot|
    plot.data << lines_init(prepare_for_lines_plot(line_xs), prepare_for_lines_plot(line_ys))
    set_labels(plot, ["Px"], [points_to_predict[0][0] - 1.5], [points_to_predict[0][1]], "Bold")
    # set_labels(plot, labels, label_xs, label_ys)
    plot.data << points_init(*plot_regular.transpose, "regular", "1", "black") # regular
    plot.data << points_init(*plot_novelty.transpose, "anomaly", "2", "blue") # novelty
  end
end
