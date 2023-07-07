# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'
require "ml/forest"
require 'ml/service/isolation/novelty'

require 'ml/experiment/preprocessor'

file = File.readlines('data/clicked/data.csv')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1...-1].map { |line| line.chomp.split(',') }


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
  (fqr - 2.5 * iqr)..(tqr + 2.5 * iqr)
end

pp ranges = input[0].length.times.map { |x| column_minmax(input + outliers, x) }

# TODO: HERE SWITCH TO NOVELTY
service = Ml::Service::Isolation::Novelty.new(batch_size: 128, max_depth: 50, ranges: ranges)
forest = Ml::Forest::Tree.new(input, trees_count: 100, forest_helper: service)

evaluated_data = outliers.map { |x| forest.fit_predict(x, forest_helper: service) }
# pp evaluated_data.map { |x| x.to_h }
hash = evaluated_data.map { |x| x }
p outliers.count

pp hash.select { |x| x if x.novelty? == true }.count

evaluated_data = input.map { |x| forest.fit_predict(x, forest_helper: service) }
# pp evaluated_data.map { |x| x.to_h }
hash = evaluated_data.map { |x| x }
p input.count

pp hash.select { |x| x if x.novelty? == false }.count
