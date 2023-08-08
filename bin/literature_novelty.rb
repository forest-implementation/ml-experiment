# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'
require "ml/forest"
require 'ml/service/isolation/novelty'

require 'ml/experiment/preprocessor'
require 'stats/statistics'

include Stats::Statistics

# file = File.readlines('data/clicked/data.csv')
# file = File.readlines('data/anomalies/http.csv')
file = File.readlines('data/donors/donors_norm.csv')
# file = File.readlines('data/anomalies/shuttle.csv')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1..-1].map { |line| line.chomp.split(',') }
# for diabetic bcs it contains one more useless column
# data = data.map {|x| x[1...-1]}


# pp adjusted_box([[1],[2],[3]],0)

regular = Ml::Experiment::Preprocessor.filter_normal(data,normal_class: "0")
outliers = Ml::Experiment::Preprocessor.filter_outliers(data,normal_class: "0")

pp "regular length #{regular.length}"

input_sample = regular.sample(10000)
input_semple = regular.sample(1000)
# pp ranges = regular[0].length.times.map { |x| column_deviation(regular.sample(10000), x) }
# pp ranges = regular[0].length.times.map { |x| notched_box(regular, x) }
pp ranges = regular[0].length.times.map { |x| adjusted_box(input_sample, x) }


# experiment start

service = Ml::Service::Isolation::Novelty.new(batch_size: 128, max_depth: 16,  ranges: ranges)


forest = Ml::Forest::Tree.new(input_sample, trees_count: 100, forest_helper: service)


pp "novelties out of regular sample (#{input_sample.count})"
pp input_sample.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| x.novelty? }
pp "novelites out of regular semple"
pp input_semple.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| x.novelty? }
pp "novelites out of mocked outliers (#{outliers.count})"
pp outliers.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| x.novelty? }

