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

pp ranges = input[0].length.times.map { |x| adjusted_box(input, x) }

service = Ml::Service::Isolation::Outlier.new(batch_size: 128)
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: service)

novelty_service = Ml::Service::Isolation::Novelty.new(batch_size: 30, max_depth: 4, ranges: ranges)

points_to_predict = [[9, 7], [5, 2.1], [4.5, 2.2], [4.8, 2.0]]
pp(points_to_predict.map { |point| forest.fit_predict(point, forest_helper: novelty_service) })

Plotting::Plotter.save_svg_figure(input, points_to_predict, "figures/example1.svg", {
                                    # :height => 300,
                                    # :width => 500,
                                    # :key => true,
                                    # :scale_x_integers => true,
                                    # :scale_y_integers => true,
                                    show_data_points: true, # for scatter functionality
                                    show_lines: false, # for scatter functionality
                                    min_x_value: ranges[0].min,
                                    max_x_value: ranges[0].max,

                                    min_y_value: ranges[1].min,
                                    max_y_value: ranges[1].max
                                  })
