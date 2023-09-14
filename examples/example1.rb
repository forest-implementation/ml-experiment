# frozen_string_literal: true

require "bundler/setup"
require "svggraph" # https://github.com/lumean/svg-graph2
require "SVG/Graph/Plot"

require "ml/experiment/preprocessor"
require "plotting/plotter"

require "ml/forest"
require "ml/service/isolation/outlier"
require "ml/service/isolation/novelty"
require "stats/statistics"

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
pp forest
def splitpoints(key, tree, &fun)
  return [key, tree.data.depth] if tree.is_a?(Node::OutNode)

  fun.call [key, tree.split_point]
  tree.branches.map { |key, x| splitpoints(key, x) { |x| fun.call x } }
end

f = Enumerator.new do |y|
  splitpoints(ranges, forest.trees[0]) { |x| y << x }
end

lines_coords = f.map do |range, split_point|
  range[1 - split_point.dimension].minmax.map do |x|
    split_point.dimension == 1 ? [x, split_point.split_point] : [split_point.split_point, x]
  end
end

# pp lines_coords

def splitpoints2(key, tree, &fun)
  return fun.call [key, tree.data.depth] if tree.is_a?(Node::OutNode)

  tree.branches.map { |key, x| splitpoints2(key, x) { |x| fun.call x } }
end

s = Enumerator.new do |y|
  splitpoints2(ranges, forest.trees[0]) { |x| y << x }
end

points_to_predict = [[8, 7], [5, 2.1], [4.5, 2.2], [4.8, 2.0]]
pred_input = input.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }
pred_additional = points_to_predict.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }

input_novelty = input.zip(pred_input).filter { |_coord, score| score.novelty? }.map { |x| x[0] }

pp(input.zip(pred_input).filter { |_coord, score| score.novelty? })
pp(input.zip(pred_input).filter { |_coord, score| !score.novelty? })

input_regular = input.zip(pred_input).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }

additional_novelty = points_to_predict.zip(pred_additional).filter { |_coord, score| score.novelty? }.map { |x| x[0] }
additional_regular = points_to_predict.zip(pred_additional).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }

Plotting::Plotter.save_svg_figure(input_regular, input_novelty, "figures/example1_0.svg", {
                                    height: 300,
                                    width: 500,
                                    # :key => true,
                                    # :scale_x_integers => true,
                                    # :scale_y_integers => true,
                                    show_data_points: true, # for scatter functionality
                                    show_lines: false, # for scatter functionality
                                    min_x_value: ranges[0].min,
                                    max_x_value: ranges[0].max,

                                    min_y_value: ranges[1].min,
                                    max_y_value: ranges[1].max,
                                    lines_coords: lines_coords,
                                    depth_coords_text: s,
                                    additional_points: [[-5.82, 0.22]]
                                  })

Plotting::Plotter.save_svg_figure(input_regular + additional_regular, input_novelty + additional_novelty, "figures/example1_1.svg", {
                                    height: 300,
                                    width: 500,
                                    # :key => true,
                                    # :scale_x_integers => true,
                                    # :scale_y_integers => true,
                                    show_data_points: true, # for scatter functionality
                                    show_lines: false, # for scatter functionality
                                    min_x_value: ranges[0].min,
                                    max_x_value: ranges[0].max,

                                    min_y_value: ranges[1].min,
                                    max_y_value: ranges[1].max,
                                    lines_coords: lines_coords,
                                    depth_coords_text: s,
                                    additional_points: [[-5.82, 0.22]]
                                  })
