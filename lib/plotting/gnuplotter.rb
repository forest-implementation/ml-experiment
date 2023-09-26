require "gnuplot"

module Plotting
  module Gnuplotter
    def plot(path, x_ranges, y_ranges, &fun)
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.terminal "svg"
          plot.output File.expand_path(path, __dir__)
          plot.xrange "[#{x_ranges[0]}:#{x_ranges[1]}]"
          plot.yrange "[#{y_ranges[0]}:#{y_ranges[1]}]"
          plot.notitle
          # plot.xlabel "X"
          # plot.ylabel "Y"
          plot.key "left"

          fun.call(plot)
        end
      end
    end

    def points_init(x, y, title)
      Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "points"
        ds.title = title
      end
    end

    def lines_init(x, y)
      Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "lines"
        ds.notitle
      end
    end

    # usage: set_labels(x, ["label1", "label2", "label3"], [x1, x2, x3], [y1, y2, y3])
    def set_labels(plot, labels, xs, ys, style = "")
      pos = xs.zip(ys)
      labels.zip(pos).each do |label, xy|
        set_label(plot, label, xy[0], xy[1], style)
      end
    end

    def set_label(plot, label, x, y, style = "")
      plot.label "'{/:#{style} #{label}}' at #{x},#{y}"
    end

    def set_rects(plot, x1y1x2y2, style: "fc rgb '#BD73BD' fs solid #{1.0/8}" )
      x1y1x2y2.each do |x1y1, x2y2|
        set_rect(plot, x1y1[0], x1y1[1], x2y2[0], x2y2[1], style: style)
      end
    end

    def set_rect(plot, x1, y1, x2, y2, style: "fc rgb 'gray'")
      plot.object "rect from #{x1},#{y1} to #{x2},#{y2} #{style} "
    end
  end
end
