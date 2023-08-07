# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'
require "ml/forest"
require 'ml/service/isolation/novelty'

require 'ml/experiment/preprocessor'
require "matrix"

# file = File.readlines('data/clicked/data.csv')
# file = File.readlines('data/anomalies/http.csv')
# file = File.readlines('data/donors/donors_norm.csv')
file = File.readlines('data/anomalies/shuttle.csv')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1..-1].map { |line| line.chomp.split(',') }
# for diabetic bcs it contains one more useless column
# data = data.map {|x| x[1...-1]}


def column_minmax(input, index)
  min, max = input.map { |x| x[index] }.minmax
  (min..max)
end

def quantil(sorted, p = 0.25)
  h = (sorted.length + 1)*p - 1
  sorted[h.floor] + (h - h.floor) * (sorted[h.ceil] - sorted[h.floor])
end
    
def column_deviation(input, index)
  sorted = input.map { |x| x[index] }.sort
  fqr, tqr = quantil(sorted, 0.25), quantil(sorted, 0.75)
  iqr = tqr - fqr
  (fqr - 1.5 * iqr)..(tqr + 1.5 * iqr)
end


def median(sorted)
  mid = sorted.length / 2
  sorted.length.odd? ? sorted[mid] : 0.5 * (sorted[mid] + sorted[mid - 1])
end

raise "median test failed" unless median([1,2,3,4,5]) == 3 
raise "median test failed" unless median([1,2,3,4]) == 2.5 


def sgn(x)
  return -1 if x < 0
  return 0 if x == 0
  return 1 if x > 0
end

def h_index(i,j, zplus,zminus, p)
  a = zplus[i]
  b = zminus[j]
  a == b ? sgn(p -1 - i - j): (a+b)/(a-b)
end

def naive_medcouple(sorted_arr)
  reversed = sorted_arr.reverse

  xm = median(sorted_arr)
  xscale = 2* reversed.map(&:abs).max
  zplus = reversed.filter { |x| x >= xm }.map { |x| (x-xm)/xscale.to_f }
  zminus = reversed.filter { |x| x <= xm }.map { |x| (x-xm)/xscale.to_f }
  p = zplus.size
  q = zminus.size
  first = (0..p-1)
  second = (0..q-1)
  h_value = first.to_a.product(second.to_a).map { | x,y | h_index(x,y, zplus, zminus, p)}
  median(h_value.sort)
end


raise "naive medcouple error" unless sprintf("%.3f", naive_medcouple([1,2,3,4,7,8])) == "0.286"
raise "naive medcouple error" unless naive_medcouple([1,2,3,4,5,6]) == 0.0
raise "naive medcouple error" unless naive_medcouple([1,2,3,4,5]) == 0.0



raise "quantil error" unless quantil([1,2,3,4,5,6,7], 0.25) == 2
raise "quantil error" unless quantil([1,2,3,4,5,6,7], 0.75) == 6
raise "quantil error" unless quantil([1,2,3,4,5,6,7,8], 0.25) == 2.25
raise "quantil error" unless quantil([1,2,3,4,5,6,7,8], 0.75) == 6.75


def adjusted_box(input, index)
  s = input.map { |x| x[index] }
  sorted = s.sort
  fqr, tqr = quantil(sorted, 0.25), quantil(sorted, 0.75)
  iqr = tqr - fqr
  med = naive_medcouple(sorted)
  pp "medoucple #{med}"
  return  (fqr - 1.5*iqr* Math::E ** (-4*med))..(tqr + 1.5*iqr*Math::E ** (3*med)) if med >= 0
  return (fqr - 1.5*iqr* Math::E ** (-3*med))..(tqr + 1.5*iqr*Math::E ** (4*med)) if med <= 0
end

# pp adjusted_box([[1],[2],[3]],0)

regular = Ml::Experiment::Preprocessor.filter_normal(data)
outliers = Ml::Experiment::Preprocessor.filter_outliers(data)

pp "regular length #{regular.length}"

# pp ranges = regular[0].length.times.map { |x| column_deviation(regular.sample(10000), x) }
# pp ranges = regular[0].length.times.map { |x| notched_box(regular, x) }
pp ranges = regular[0].length.times.map { |x| adjusted_box(regular.sample(10000), x) }


# experiment start

service = Ml::Service::Isolation::Novelty.new(batch_size: 128, max_depth: 16,  ranges: ranges)

input_sample = regular.sample(1000)
input_semple = regular.sample(1000)

forest = Ml::Forest::Tree.new(input_sample, trees_count: 100, forest_helper: service)


pp "novelties out of regular sample (#{input_sample.count})"
pp input_sample.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| x.novelty? }
pp "novelites out of regular semple"
pp input_semple.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| x.novelty? }
pp "novelites out of mocked outliers (#{outliers.count})"
pp outliers.map { |x| forest.fit_predict(x, forest_helper: service) }.count{ |x| x.novelty? }

