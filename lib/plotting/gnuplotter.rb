require "gnuplot"

module Plotting
  module Gnuplotter
    def plot(&fun)
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.terminal "svg"
          plot.output File.expand_path("../../figures/sin_wave.svg", __dir__)

          plot.title  "Array Plot Example"
          plot.ylabel "x^2"
          plot.xlabel "x"
          plot.key "right"

          fun.call(plot)
        end
      end
    end

    def dataset_init(x, y)
      Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "lines"
        ds.title = "array data"
      end
    end
  end
end
