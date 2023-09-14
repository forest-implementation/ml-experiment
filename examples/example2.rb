# require "gnuplot"
# Gnuplot.open do |gp|
#   Gnuplot::Plot.new(gp) do |plot|
#     plot.terminal "svg"
#     plot.output File.expand_path("../figures/sin_wave.svg", __dir__)

#     plot.title  "Array Plot Example"
#     plot.ylabel "x^2"
#     plot.xlabel "x"
#     plot.key "right"

#     x = (0..50).collect(&:to_f)
#     y = x.collect { |v| v**2 }

#     plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
#       ds.with = "linespoints"
#       ds.title = "array data"
#     end
#   end
# end

require "plotting/gnuplotter"
include Plotting::Gnuplotter

plot do |x|
  x.data << dataset_init([1, 2, 3], [1, 2, 3])
  x.data << dataset_init([1, 2, 3], [3, 2, 1])
  x.data << dataset_init([1, 2, 3], [2, 3, 1])
end
