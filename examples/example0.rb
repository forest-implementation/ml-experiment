# frozen_string_literal: true

require "bundler/setup"

require "ml/experiment/preprocessor"
require "ml/forest"
require "ml/service/isolation/outlier"
require "ml/service/isolation/novelty"
require "stats/statistics"
require "plotting/gnuplotter"
require "plotting/preprocessor"

include Plotting::Gnuplotter
include Plotting::Preprocessor
include Stats::Statistics

pp input = [
  [12.6, 3.2],
  [22.3, 6.55],
  [21.4, 2.35],
  [22.45, 5.45],
  [17.8, 5.8],
  [13.05, 3.45],
  [23.55, 4.9],
  [16.75, 5.1],
  [17.7, 3.8],
  [18.45, 5.6],
  [19.9, 3.05],
  [16.5, 5.05],
  [19.95, 5.25],
  [20.9, 6.05],
  [14.45, 5.2],
  [21.1, 3.25],
  [19.65, 6.0],
  [16.4, 3.75],
  [22.35, 3.45],
  [21.2, 4.45],
  [15.65, 5.8],
  [20.05, 6.75],
  [20.5, 3.9],
  [14.5, 3.75],
  [15.95, 6.3],
  [20.25, 4.85],
  [19.1, 4.65],
  [15.85, 3.95],
  [21.05, 4.55],
  [11.6, 4.15]
]

plot_regular = input

plot("../../figures/example0_gnu.svg", plot_regular.transpose[0].minmax, plot_regular.transpose[1].minmax) do |plot|
  plot.data << points_init(*plot_regular.transpose, "regular") # regular
end
