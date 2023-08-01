# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'

require 'ml/experiment/preprocessor'

# file = File.readlines('data/clicked/data.csv')
file = File.readlines('data/donors/donors_norm.csv')
# file = File.readlines('data/anomalies/shuttle.csv')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1..-1].map { |line| line.chomp.split(',') }

input = Ml::Experiment::Preprocessor.filter_normal(data)
outliers = Ml::Experiment::Preprocessor.filter_outliers(data)


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


def check_simple_normal(element, ranges)
  element.zip(ranges).map {|x,y| y.include?(x)}.count { |x| not x} <= 0 
end

input_sample = input.sample(10000)
input_semple = input.sample(10000)

p input_sample.count{|x| check_simple_normal x, ranges }
p input_semple.count{|x| check_simple_normal x, ranges }
p outliers.count{|x| not check_simple_normal x, ranges }

p outliers.count

p input_semple.count

