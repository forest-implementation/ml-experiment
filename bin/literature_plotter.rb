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

input = Ml::Experiment::Preprocessor.filter_normal(data, normal_class: "1")
novelties = Ml::Experiment::Preprocessor.filter_outliers(data, normal_class: "1")

input = input.map { |x| [x[0] * 1, x[1] * 10] }
pp ranges = input[0].length.times.map { |x| adjusted_box(input, x) }

service = Ml::Service::Isolation::Outlier.new(batch_size: 128)
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: service)

evaluated_data = input.map { |x| { x: x, prediction?: forest.fit_predict(x, forest_helper: service).outlier? } }
grouped = evaluated_data.group_by { |datahash| datahash[:prediction?] == false }
regular = grouped[true].map { |hash| hash.values_at(:x)[0] }
outlier = grouped[false].map { |hash| hash.values_at(:x)[0] }
pp regular.count
pp outlier.count

require "SVG/Graph/DataPoint"
pp DataPoint::CRITERIA

DataPoint.configure_shape_criteria(
  [/.*/, lambda { |x, y, line|
    if line == 1

      ["circle", {
        "cx" => x,
        "cy" => y,
        "r" => "2.5",
        "stroke" => "black"
        # "class" => "dataPoint#{line}"
      }]

    else

      ["circle", {
        "cx" => x,
        "cy" => y,
        "r" => "2.5",
        "stroke" => "black",
        "stroke-width" => "1",
        "fill" => "none"
        # "class" => "dataPoint#{line}"
      }]
    end
  }]
)

# regular = regular.map{|x| [x[0] * 1, x[1] * 10]}

Plotting::Plotter.save_svg_figure(regular, outlier, path = "figures/literature.svg", config = {
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
