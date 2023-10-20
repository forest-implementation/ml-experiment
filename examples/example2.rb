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

service = Ml::Service::Isolation::Outlier.new(batch_size: input.size, max_depth: 5)

forest = Ml::Forest::Tree.new(input, trees_count: 4, forest_helper: service)

points_to_predict = [[10, 6]]
input += points_to_predict

pred_input = input.map { |point| forest.fit_predict(point, forest_helper: service) }

# pred_to_predict = points_to_predict.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }

input_novelty = input.zip(pred_input).filter { |_coord, score| score.outlier? }.map { |x| x[0] }

input_regular = input.zip(pred_input).filter { |_coord, score| !score.outlier? }.map { |x| x[0] }

# to_predict_novelty = points_to_predict.zip(pred_to_predict).filter { |_coord, score| score.outlier? }.map { |x| x[0] }
# to_predict_regular = points_to_predict.zip(pred_to_predict).filter { |_coord, score| !score.outlier? }.map { |x| x[0] }

def rectangles_coords(tree, &fun)
  if tree.is_a?(Node::OutNode)
    return fun.call({ "borders" => tree.minmaxborders,
                      "depth" => tree.data.depth + Evaluatable.evaluate_path_length_c(tree.data.data.size) })
  end

  fun.call({ "borders" => tree.minmaxborders, "depth" => -1 })
  tree.branches.map { |_key, x| rectangles_coords(x) { |x| fun.call x } }
end

(0...forest.trees.size).each do |i|
  s = Enumerator.new do |y|
    rectangles_coords(forest.trees[i]) { |x| y << x }
  end

  def split_line_coords(tree, &fun)
    return false if tree.is_a?(Node::OutNode)

    def calc_sp_coords(tree)
      tree.minmaxborders.transpose[1 - tree.split_point.dimension].map do |x|
        tree.split_point.dimension == 1 ? [x, tree.split_point.split_point] : [tree.split_point.split_point, x]
      end
    end

    fun.call calc_sp_coords(tree)
    tree.branches.map { |_key, x| split_line_coords(x) { |x| fun.call x } }
  end

  r = Enumerator.new do |y|
    split_line_coords(forest.trees[i]) { |x| y << x }
  end

  pp "line coords r"
  pp r.to_a

  pp "rect coords s"

  s = s.filter { |obj| !obj["borders"].empty? }
  pp s.to_a

  def prepare_depth_labels(split_depths_array)
    split_depths_array.map do |ranges, depth|
      x = ranges[0].minmax.sum / 2.0
      y = ranges[1].minmax.sum / 2.0
      [depth, x, y]
    end
  end

  plot_regular = input_regular # + to_predict_regular
  plot_novelty = input_novelty # + to_predict_novelty

  # plot("../../figures/example2_gnu.svg", input.transpose[0].minmax, input.transpose[1].minmax) do |plot|
  plot("../../figures/example2_gnu#{i}.svg", [-5.5, 24], [0.5, 7.5]) do |plot|
    plot.data << lines_init(prepare_for_lines_plot(r.to_a.flatten(1).transpose[0]),
                            prepare_for_lines_plot(r.to_a.flatten(1).transpose[1]))
    set_rects(plot, s.to_a)
    set_labels(plot, ["Px"], [points_to_predict[0][0] - 1.5], [points_to_predict[0][1]], "Bold")
    plot.data << points_init(*plot_regular.transpose, "regular", "1", "black") # regular
    plot.data << points_init(*plot_novelty.transpose, "outlier", "2", "blue") # novelty
    # set_labels(plot, %w[Px B], [15 - 1, 7], [2.5 + 0.1, 7], style = "Bold")
    # set_labels(plot, labels, label_xs, label_ys)
  end
end
