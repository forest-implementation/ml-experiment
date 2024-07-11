# frozen_string_literal: true

require "bundler/setup"

require "ml/experiment/preprocessor"
require "ml/forest"
require "ml/service/isolation/outlier"
require "ml/service/isolation/novelty"
require "ml/service/isolation/noutlier"
require "stats/statistics"
require "plotting/gnuplotter"
require "plotting/preprocessor"
require "plotting/graphviz"

include Plotting::Gnuplotter
include Plotting::Preprocessor
include Stats::Statistics
include Plotting::Graphviz

# TODO: PADA TO HNUSNĚ
data = [
25.0,100.0,"a",
30.0,90.0,"a",
20.0,90.0,"a",
35.0,85.0,"a",
25.0,85.0,"a",
15.0,85.0,"a",
105.0,20.0,"a",
95.0,25.0,"a",
95.0,15.0,"a",
90.0,30.0,"a",
90.0,20.0,"a",
90.0,10.0,"a",
25.0,20.0,"b",
].each_slice(3)


# data = data.map{|triple| [105 - triple[0], 105-triple[1], triple[2]]}
pp data

input = data.filter { |x| x[2] == "a" }.map { |x| [x[0], x[1]] }
novelty_point = data.filter { |x| x[2] == "b" }.map { |x| [x[0], x[1]] }
predict = input + novelty_point

# for noutlier
# ranges = Ml::Service::Isolation::Noutlier.min_max(input)
# ranges = input[0].length.times.map { |dim| adjusted_box(input, dim) }
ranges = [[0,110],[-5,105]]
novelty_service = Ml::Service::Isolation::Novelty.new(
  batch_size: input.size,
  max_depth: 10,
  ranges: ranges,
  random: Random.new(113)
)

pp "staert"
forest = Ml::Forest::Tree.new(input, trees_count: 1, forest_helper: novelty_service)
pp "end"

pp predict

pred_input = predict.map do |point|
  forest.fit_predict(point, novelty_service)
end

#ranges = novelty_service.ranges

input_regular = predict.zip(pred_input).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }
input_novelty = predict.zip(pred_input).filter { |_coord, score| score.novelty? }.map { |x| x[0] }

pp predict.zip(pred_input)

depths_for_tree = Enumerator.new do |y|
  deep_depths(ranges, forest.trees[0]) { |x| y << x }
end

tree_nodes = Enumerator.new do |y|
  tree_nodes(forest.trees[0]) { |x| y << x }
end

tree_nodes = tree_nodes.filter {|x| x["borders"][0].size != 0 }


nodes = tree_nodes.map { |node| [node["borders"], { label: label_pretty_print(node) }] }

save_graph(create_graph(nodes, depths_for_tree), "figures/example6_novelty_tree_bt.svg")

Gnuplot.open do |gp|
  s = Enumerator.new do |y|
    rectangles_coords(forest.trees[0]) { |x| y << x }
  end

  r = prepare_lines(ranges, forest)

  s = s.filter { |obj| !obj["borders"].empty? && obj["borders"][0].size != 0 }

  plot_regular = input_regular
  plot_novelty = input_novelty


  plot(gp, "../../figures/example6_noutlier_gnu.svg", [predict.transpose[0].min,110], predict.transpose[1].minmax, key="right") do |plot|
  # plot(gp, "../../figures/example6_noutlier_gnu.svg", [100.0, 500], [0.0, 150]) do |plot|
    set_rects(plot, s.to_a)
    plot.data << lines_init(prepare_for_lines_plot(r[0]),
                            prepare_for_lines_plot(r[1]))
    set_labels(plot, ["Px"], [novelty_point[0][0] - 1.5], [novelty_point[0][1] - 2.5], "Bold")
    plot.data << points_init(*plot_regular.transpose, "regular", "1", "black") # regular
    plot.data << points_init(*plot_novelty.transpose, "anomaly", "2", "blue") # novelty
    # set_labels(plot, %w[Px B], [15 - 1, 7], [2.5 + 0.1, 7], style = "Bold")
    # set_labels(plot, labels, label_xs, label_ys)
  end
end
