# frozen_string_literal: true

require "bundler/setup"

require 'rubystats'
require 'plotting/plotter'

norm = Rubystats::NormalDistribution.new(0.0, 1.0)
actual_y = 100.times.map { |_| norm.rng }
actual_x = (0...100).to_a

projection_y = 100.times.map { |_| norm.rng }
projection_x = (0...100).to_a

actual = actual_x.zip(actual_y)
projection = projection_x.zip(projection_y)


Plotting::Plotter.save_svg_figure(actual, projection)



