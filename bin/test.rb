# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'
require "ml/forest"
require 'ml/service/isolation/novelty'

require 'ml/experiment/preprocessor'

file = File.readlines('data/literature/Shuttle/Shuttle_withoutdupl_v10.arff')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1...-1].map { |line| line.chomp.split(',') }

# get normal data for learning
input = Ml::Experiment::Preprocessor.filter_normal(data)
outliers = Ml::Experiment::Preprocessor.filter_outliers(data)
# learning input

input = [[0.51], [0.50], [0.45], [0.47]]
service = Ml::Service::Isolation::Novelty.new(batch_size: input.size, max_depth: 10)
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: service)

outliers = [[0.46], [0.89], [0.99], [50]]

evaluated_data = input.map { |x| forest.fit_predict(x, forest_helper: service) }
pp evaluated_data.map { |x| x.to_h }

