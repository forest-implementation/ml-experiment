# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'
require "ml/forest"
require 'ml/service/isolation/novelty'

require 'ml/experiment/preprocessor'

# file = File.readlines('data/clicked/data.csv')
# file = File.readlines('data/anomalies/http.csv')
# file = File.readlines('data/donors/donors_norm.csv')
file = File.readlines('data/anomalies/shuttle.csv')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1..-1].map { |line| line.chomp.split(',') }
# for diabetic bcs it contains one more useless column
# data = data.map {|x| x[1...-1]}

# data = data.sample(10000)
# get normal data for learning
input = Ml::Experiment::Preprocessor.filter_normal(data)
outliers = Ml::Experiment::Preprocessor.filter_outliers(data)

# learning input

def column_minmax(input, index)
  min, max = input.map { |x| x[index] }.minmax
  (min..max)
end

def column_deviation(input, index)
  s = input.map { |x| x[index] }.sort
  fqr = s[s.length / 4]
  tqr = s[s.length / (4.0 / 3.0)]
  iqr = tqr - fqr
  (fqr - 1.5 * iqr)..(tqr + 1.5 * iqr)
end

pp ranges = input[0].length.times.map { |x| column_deviation(input, x) }


service = Ml::Service::Isolation::Novelty.new(batch_size: 128, max_depth: 16,  ranges: ranges)

input_sample = input.sample(10000)
input_semple = input.sample(10000)

forest = Ml::Forest::Tree.new(input_sample, trees_count: 100, forest_helper: service)

evaluated_data = outliers.map { |x| forest.fit_predict(x, forest_helper: service) }
# pp evaluated_data.map { |x| x.to_h }
hash = evaluated_data.map { |x| x }
p outliers.count
p input_sample.count

pp input_sample.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| not x.novelty? }
pp input_semple.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| not x.novelty? }
pp outliers.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| x.novelty? }

