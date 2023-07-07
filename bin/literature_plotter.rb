# frozen_string_literal: true

require "bundler/setup"
require 'svggraph' # https://github.com/lumean/svg-graph2
require 'SVG/Graph/Plot'

require 'ml/experiment/preprocessor'
require 'plotting/plotter'

file = File.readlines('data/clicked/data.csv')

data = file.drop_while { |v| !v.start_with? '@DATA' }[1...-1].map { |line| line.chomp.split(',') }

input = Ml::Experiment::Preprocessor.filter_normal(data)
outliers = Ml::Experiment::Preprocessor.filter_outliers(data)

Plotting::Plotter.save_svg_figure(input, outliers, path="figures/literature.svg")