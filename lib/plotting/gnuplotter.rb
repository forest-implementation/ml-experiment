require "gnuplot"

module Plotting
  module Gnuplotter
    def plot(gp, path, x_ranges, y_ranges, key = "left", &fun)
      Gnuplot::Plot.new(gp) do |plot|
        plot.terminal "svg"
        plot.output File.expand_path(path, __dir__)
        plot.xrange "[#{x_ranges[0]}:#{x_ranges[1]}]"
        plot.yrange "[#{y_ranges[0]}:#{y_ranges[1]}]"
        plot.notitle
        # plot.xlabel "X"
        # plot.ylabel "Y"
        plot.key key

        fun.call(plot)
      end
    end

    def points_init(x, y, title, pointtype = "1", color = "red")
      Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "points pointtype #{pointtype} lc rgbcolor '#{color}'"
        ds.title = title
      end
    end

    def lines_init(x, y)
      Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "lines lw 1.6 lc rgb '#AE000000'"
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

    def rect_inside?(out, inside)
      out_x1 = out[0][0]
      out_y1 = out[0][1]
      out_x2 = out[1][0]
      out_y2 = out[1][1]

      inside_x1 = inside[0][0]
      inside_y1 = inside[0][1]
      inside_x2 = inside[1][0]
      inside_y2 = inside[1][1]

      (inside_x1 >= out_x1 && inside_x2 <= out_x2) && (inside_y1 >= out_y1 && inside_y2 <= out_y2)
    end

    def get_children(rects, rect)
      rects.filter do |their_rect|
        rect_inside?(rect, their_rect)
      end
    end

    def set_rects(plot, x1y1x2y2, style: "fc rgb '#BD73BD' fs solid #{1.0 / 10}")
      x1y1x2y2.each do |hash|
        # children = get_children(x1y1x2y2.map { |x| x["borders"] }, hash["borders"])
        set_rect(plot, *hash["borders"][0].minmax, *hash["borders"][1].minmax, style: style,
                                                                               label: hash["depth"])
      end
    end

    def set_rect(plot, x1, x2, y1, y2, style: "fc rgb 'gray'", label: 0)
      plot.object "rect from #{x1},#{y1} to #{x2},#{y2} #{style} lw 0.05"
      # plot only if last layer
      plot.label "at #{(x2 + x1 - 0.4) / 2},#{(y2 + y1) / 2} '#{label.round(2)}' back font',8'" if label != -1
    end
  end
end
