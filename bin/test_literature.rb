# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'
require "ml/forest"
require 'ml/service/isolation/novelty'

require 'ml/experiment/preprocessor'

file = File.readlines('data/literature/Lymphography/Lymphography_withoutdupl_norm_catremoved.arff')


data = file.drop_while { |v| !v.start_with? '@DATA' }[1...-1].map { |line| line.chomp.split(',') }

# get normal data for learning
input = Ml::Experiment::Preprocessor.filter_normal(data)
pp input
outliers = Ml::Experiment::Preprocessor.filter_outliers(data).map { |x| x.map{ |y| y * 2} }
# learning input

service = Ml::Service::Isolation::Novelty.new(batch_size: 64, max_depth: 50)
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: service)

#pp input.sort { |x,y| x[0] < y[0]}
pp input.map { |x| x[0]}.sort[250]
pp input.map { |x| x[0]}.sort[750]

evaluated_data = outliers.map { |x| forest.fit_predict(x, forest_helper: service) }
#pp evaluated_data.map { |x| x.to_h }
hash = evaluated_data.map { |x| x }
p outliers.count
p hash.select { |x| x if x.novelty? == true }.count

evaluated_data = input.map { |x| forest.fit_predict(x, forest_helper: service) }
#pp evaluated_data.map { |x| x.to_h }
hash = evaluated_data.map { |x| x }
p input.count
p hash.select { |x| x if x.novelty? == false }.count
