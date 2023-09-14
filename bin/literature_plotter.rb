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

file = File.readlines("data/clicked/data.csv")

data = file.drop_while { |v| !v.start_with? "@DATA" }[1...-1].map { |line| line.chomp.split(",") }

pp input = Ml::Experiment::Preprocessor.filter_normal(data, normal_class: "1").sample(30)

novelties = Ml::Experiment::Preprocessor.filter_outliers(data, normal_class: "1")

pp ranges = input[0].length.times.map { |x| adjusted_box(input, x) }

novelty_service = Ml::Service::Isolation::Novelty.new(batch_size: 30, max_depth: 4, ranges: ranges)
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: novelty_service)

points_to_predict = [[9, 7], [5, 2.1], [4.5, 2.2], [4.8, 2.0]]
pp(points_to_predict.map { |point| forest.fit_predict(point, forest_helper: novelty_service) })

Plotting::Plotter.save_svg_figure(input, points_to_predict, "figures/literature.svg", {
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
