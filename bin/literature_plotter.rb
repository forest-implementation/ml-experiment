# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'

require 'ml/experiment/preprocessor'
require 'plotting/plotter'


require "ml/forest"
require 'ml/service/isolation/outlier'

file = File.readlines('data/clicked/data.csv')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1...-1].map { |line| line.chomp.split(',') }

input = Ml::Experiment::Preprocessor.filter_normal(data, normal_class: "1")
novelties = Ml::Experiment::Preprocessor.filter_outliers(data, normal_class: "1")

service = Ml::Service::Isolation::Outlier.new(batch_size: 128, )
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: service)

evaluated_data = input.map { |x| {x: x, prediction?: forest.fit_predict(x, forest_helper: service).outlier?} }
grouped = evaluated_data.group_by {|datahash| datahash[:prediction?] == false}
regular = grouped[true].map{ |hash| hash.values_at(:x)[0]}
outlier = grouped[false].map{ |hash| hash.values_at(:x)[0]}
pp regular.count
pp outlier.count

Plotting::Plotter.save_svg_figure(regular + novelties, outlier, path="figures/literature.svg")