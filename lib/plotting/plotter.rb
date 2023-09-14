require "svggraph" # https://github.com/lumean/svg-graph2
require "SVG/Graph/Plot"

DataPoint.configure_shape_criteria(
  [/.*/, lambda { |x, y, line|
    if line == 1
      ["circle", {
        "cx" => x,
        "cy" => y,
        "r" => "2",
        "stroke" => "black"
        # "class" => "dataPoint#{line}"
      }]

    else

      ["circle", {
        "cx" => x,
        "cy" => y,
        "r" => "2",
        "stroke" => "black",
        "stroke-width" => "0.5",
        "fill" => "none"
        # "class" => "dataPoint#{line}"
      }]
    end
  }]
)

class SVG::Graph::Graph
  def burn
    add_data({
               data: [[5, 5], [5, 5]],
               title: "Regular"
             })
    start_svg
    calculate_graph_dimensions
    @foreground = Element.new("g")
    draw_graph
    # draw_titles
    # draw_legend
    @graph.add_element(@foreground)
    style

    data = ""
    @doc.write(data, 0)

    if @config[:compress]
      if defined?(Zlib)
        inp, out = IO.pipe
        gz = Zlib::GzipWriter.new(out)
        gz.write data
        gz.close
        data = inp.read
      else
        data << "<!-- Ruby Zlib not available for SVGZ -->"
      end
    end

    data
  end
end

# monkey patch init
class SVG::Graph::Plot < SVG::Graph::Graph
  attr_accessor :elements, :x_min_max, :y_min_max

  def initialize(config)
    @add_popups = false

    @config = config
    # array of Hash
    @data = []
    # self.top_align = self.top_font = 0
    # self.right_align = self.right_font = 0

    init_with({
                width: 500,
                height: 300,
                show_x_guidelines: false,
                show_y_guidelines: false,
                show_data_values: false,

                x_axis_position: nil,
                y_axis_position: nil,

                min_scale_value: nil,

                show_x_labels: true,
                stagger_x_labels: false,
                rotate_x_labels: false,
                step_x_labels: 1,
                step_include_first_x_label: true,

                show_y_labels: true,
                rotate_y_labels: false,
                stagger_y_labels: false,
                scale_integers: false,

                show_x_title: true,
                x_title: "X",
                x_title_location: :middle, # or :end

                show_y_title: true,
                y_title_text_direction: :bt, # other option is :tb
                y_title: "Y",
                y_title_location: :middle, # or :end

                show_graph_title: false,
                graph_title: "Graph Title",
                show_graph_subtitle: false,
                graph_subtitle: "Graph Sub Title",
                key: true,
                key_width: nil,
                key_position: :right, # bottom or right

                font_size: 12,
                title_font_size: 16,
                subtitle_font_size: 14,
                x_label_font_size: 12,
                y_label_font_size: 12,
                x_title_font_size: 14,
                y_title_font_size: 14,
                key_font_size: 10,
                key_box_size: 12,
                key_spacing: 5,

                no_css: false,
                add_popups: false,
                popup_radius: 10,
                number_format: "%.2f",
                style_sheet: "",
                inline_style_sheet: ""
              })

    init_with config
  end

  def draw_legend
    return unless key

    group = @root.add_element("g")

    key_count = 0
    for key_name in keys
      y_offset = (key_box_size * key_count) + (key_count * key_spacing)
      if key_count == 0
        group.add_element("circle", {
                            "cx" => 0.to_s,
                            "cy" => y_offset.to_s,
                            "r" => key_box_size / 2.0,
                            # "width" => key_box_size.to_s,
                            # "height" => key_box_size.to_s,
                            # "class" => "key#{key_count+1}"

                            # "r" => "2.5",
                            "stroke" => "black"
                          })
      else
        # y_offset = (key_box_size * key_count) + (key_count * key_spacing)
        group.add_element("circle", {
                            "cx" => 0.to_s,
                            "cy" => y_offset.to_s,
                            "r" => key_box_size / 2.0,
                            # "width" => key_box_size.to_s,
                            # "height" => key_box_size.to_s,
                            # "class" => "key#{key_count+1}"
                            "stroke-width" => "1",
                            "fill" => "none",
                            # "r" => "2.5",
                            "stroke" => "black"
                          })
      end
      group.add_element("text", {
                          "x" => (key_box_size + key_spacing).to_s,
                          "y" => (y_offset + key_box_size / 4.0).to_s,
                          "class" => "keyText"
                        }).text = key_name.to_s
      key_count += 1
    end

    case key_position
    when :right
      x_offset = @graph_width + @border_left + (key_spacing * 2)
      y_offset = @border_top + (key_spacing * 2)
    when :bottom
      x_offset = @border_left + (key_spacing * 2)
      y_offset = @border_top + @graph_height + key_spacing
      y_offset += max_x_label_height_px if show_x_labels
      y_offset += x_title_font_size + key_spacing if show_x_title
    end
    group.attributes["transform"] = "translate(#{x_offset} #{y_offset})"
  end

  # for adding UFO elements to graph
  # example:
  # graph_immutable.elements = [Data.define(:name, :attributes).new("rect", {
  #       "x" => "5",
  #       "y" => "5",
  #       "width" => 10,
  #       "height" => 10,
  #     })]
  def add_other_elements(graph)
    @elements.each do |element|
      if element.name == "text"
        text = graph.add_element(element.name, element.attributes)
        text.text = element.attributes["text"]
        # text.text = "hovnajs"
      else
        graph.add_element(element.name, element.attributes)
      end
    end
  end

  def draw_graph
    @graph = @root.add_element("g", {
                                 "transform" => "translate( #{@border_left} #{@border_top} )"
                               })

    # Background
    @graph.add_element("rect", {
                         "x" => "0",
                         "y" => "0",
                         "width" => @graph_width.to_s,
                         "height" => @graph_height.to_s,
                         "class" => "graphBackground"
                       })

    add_other_elements(@graph)

    draw_x_axis
    draw_y_axis

    draw_x_labels
    draw_y_labels
  end

  def x_label_range
    max_value = max_x_range
    min_value = min_x_range
    range = max_value - min_value
    # add some padding on right
    # if range == 0
    #   max_value += 10
    # else
    #   max_value += range / 20.0
    # end
    scale_range = max_value - min_value

    # either use the given step size or by default do 9 divisions.
    scale_division = scale_x_divisions || (scale_range / 9.0)
    @x_offset = 0

    if scale_x_integers
      scale_division = scale_division < 1 ? 1 : scale_division.ceil
      @x_offset = min_value.to_f - min_value.floor
      min_value = min_value.floor
    end

    [min_value, max_value, scale_division]
  end

  def get_y_values
    min_value, max_value, @y_scale_division = y_label_range
    @y_scale_division /= 9.0 while (max_value - min_value) < @y_scale_division if max_value != min_value
    rv = []
    min_value.step(max_value, @y_scale_division) { |v| rv << v }
    rv << rv[0] + 1 if rv.length == 1
    rv
  end
  alias get_y_labels get_y_values

  def y_label_range
    max_value = max_y_range
    min_value = min_y_range
    range = max_value - min_value
    # add some padding on top
    # if range == 0
    # max_value += 10
    # else
    # max_value += range / 20.0
    # end
    scale_range = max_value - min_value

    scale_division = scale_y_divisions || (scale_range / 9.0)
    @y_offset = 0

    if scale_y_integers
      # scale_division = scale_division < 1 ? 1 : scale_division.ceil
      # @y_offset = (min_value.to_f - min_value.floor).to_f
      # min_value = min_value.floor
    end

    [min_value, max_value, scale_division]
  end

  def max_y_range
    return @max_y_cache unless @max_y_cache.nil?

    # max_value = @data.collect{|x| x[:data][Y].max }.max
    # max_value = max_value > max_y_value ? max_value : max_y_value if max_y_value
    @max_y_cache = max_y_value
    @max_y_cache
  end

  # take new min and max and rescale coords accordingly

  def calc_coords_pub(xy, x_min, x_max, y_min, y_max)
    coords = { x: 0, y: 0 }
    # scale the coordinates, use float division / multiplication
    # otherwise the point will be place inaccurate
    # x - start: 0... end: 365
    # y - start: 0... end: 250
    # coords[:x] = (x + 365)
    maxAllowed = 365
    minAllowed = 0
    unscaledNum = xy[0]
    min = x_min
    max = x_max
    coords[:x] = (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
    maxAllowed = 250
    minAllowed = 0
    unscaledNum = xy[1]
    min = y_min
    max = y_max
    coords[:y] = maxAllowed - ((maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed)
    coords
  end
end

module Plotting
  class Plotter
    def self.init_with_x_y(x, y, config = {
      height: 300,
      width: 500,
      # :key => true,
      scale_x_integers: true,
      scale_y_integers: true,
      show_data_points: true, # for scatter functionality
      show_lines: false, # for scatter functionality
      min_x_value: 0,
      max_x_value: 150,

      min_y_value: 0,
      max_y_value: 39
    })
      graph_immutable = SVG::Graph::Plot.new(config)

      x_min = config[:min_x_value]
      x_max = config[:max_x_value]

      y_min = config[:min_y_value]
      y_max = config[:max_y_value]

      @x_offset = 0

      regular_points = x.map do |x|
        a = graph_immutable.calc_coords_pub(x, x_min, x_max, y_min, y_max)
        Data.define(:name, :attributes).new(
          "circle", {
            "cx" => a[:x],
            "cy" => a[:y],
            "r" => "2",
            "stroke" => "black"
          }
        )
      end

      # regular_legend = [Data.define(:name, :attributes).new(
      #   "circle", {
      #     "cx" => 0.to_s,
      #     "cy" => y_offset.to_s,
      #     "r" => key_box_size / 2.0,
      #     "stroke-width" => "1",
      #     "fill" => "none",
      #     "stroke" => "black"
      #   }
      # ), Data.define(:name, :attributes).new(
      #   "text", {
      #     "x" => a[:x],
      #     "y" => a[:y],
      #     "font-size" => "small",
      #     "text" => "Regular"
      #   }
      # )]

      regular_legend = [Data.define(:name, :attributes).new(
        "circle", {
          "cx" => 365 + 5,
          "cy" => 10,
          "r" => 20 / 5.0,
          "stroke" => "black"
          # "class" => "dataPoint#{line}"
        }
      ), Data.define(:name, :attributes).new(
        "text", {
          "x" => 365 + 13,
          "y" => 13,
          "font-size" => "small",
          "text" => "Regular"
        }
      )]

      novelty_legend = [Data.define(:name, :attributes).new(
        "circle", {
          "cx" => 365 + 5,
          "cy" => 20,
          "r" => 20 / 5.0,
          "stroke-width" => "1",
          "fill" => "none",
          "stroke" => "black"
        }
      ), Data.define(:name, :attributes).new(
        "text", {
          "x" => 365 + 13,
          "y" => 23,
          "font-size" => "small",
          "text" => "Novelty"
        }
      )]

      novelty_points = y.map do |y|
        b = graph_immutable.calc_coords_pub(y, x_min, x_max, y_min, y_max)
        Data.define(:name, :attributes).new(
          "circle", {
            "cx" => b[:x],
            "cy" => b[:y],
            "r" => "2",
            "stroke" => "black",
            "stroke-width" => "0.5",
            "fill" => "none"
          }
        )
      end

      lines = config[:lines_coords].map do |x, y|
        a = graph_immutable.calc_coords_pub(x, x_min, x_max, y_min, y_max)
        b = graph_immutable.calc_coords_pub(y, x_min, x_max, y_min, y_max)
        random = rand(0..155)
        Data.define(:name, :attributes).new(
          "line", {
            "x1" => a[:x],
            "y1" => a[:y],
            "x2" => b[:x],
            "y2" => b[:y],
            "stroke-dasharray" => "10, 5",
            "style" => "stroke:rgb(#{random},#{random},#{random}) ;stroke-width:.1"
          }
        )
      end

      texts = config[:depth_coords_text].map do |ranges, depth|
        x = ranges[0].minmax.sum / 2.0
        y = ranges[1].minmax.sum / 2.0

        a = graph_immutable.calc_coords_pub([x, y], x_min, x_max, y_min, y_max)
        Data.define(:name, :attributes).new(
          "text", {
            "x" => a[:x],
            "y" => a[:y],
            "font-size" => "small",
            "text" => depth
          }
        )
      end

      additional_point = lambda { |x, y|
        coords = graph_immutable.calc_coords_pub([x, y], x_min, x_max, y_min, y_max)
        [
          Data.define(:name, :attributes).new("rect", {
                                                "x" => coords[:x] - 5 / 2.0,
                                                "y" => coords[:y] - 5 / 2.0,
                                                "width" => 5,
                                                "height" => 5
                                              }),
          Data.define(:name, :attributes).new(
            "text", {
              "x" => coords[:x] + 5,
              "y" => coords[:y] - 5,
              "font-size" => "small",
              "text" => "Px"
            }
          )
        ]
      }

      additional_points_to_plot = config[:additional_points].map do |x, y|
        additional_point.call(x, y)
      end

      pp novelty_legend

      graph_immutable.elements = lines + texts + additional_points_to_plot.flatten + regular_points + novelty_points + regular_legend + novelty_legend

      graph_immutable
    end

    def self.save_svg_figure(x, y, path = "figures/figure.svg", config = nil)
      graph = config.nil? ? init_with_x_y(x, y) : init_with_x_y(x, y, config)
      File.open(path, "w") { |f| f.write(graph.burn_svg_only) }
    end
  end
end
