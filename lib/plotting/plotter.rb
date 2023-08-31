require "svggraph" # https://github.com/lumean/svg-graph2
require "SVG/Graph/Plot"

DataPoint.configure_shape_criteria(
  [/.*/, lambda { |x, y, line|
    if line == 1

      ["circle", {
        "cx" => x,
        "cy" => y,
        "r" => "2.5",
        "stroke" => "black"
        # "class" => "dataPoint#{line}"
      }]

    else

      ["circle", {
        "cx" => x,
        "cy" => y,
        "r" => "2.5",
        "stroke" => "black",
        "stroke-width" => "1",
        "fill" => "none"
        # "class" => "dataPoint#{line}"
      }]
    end
  }]
)

# monkey patch init
class SVG::Graph::Plot < SVG::Graph::Graph
  def initialize(config)
    @add_popups = false

    @config = config
    # array of Hash
    @data = []
    # self.top_align = self.top_font = 0
    # self.right_align = self.right_font = 0

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

    init_with({
                width: 500,
                height: 300,
                show_x_guidelines: false,
                show_y_guidelines: true,
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

    # override default values with user supplied values
    init_with config
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
      graph_immutable.add_data({
                                 data: x,
                                 title: "regular"
                               })

      graph_immutable.add_data({
                                 data: y,
                                 title: "novelty"
                               })
      graph_immutable
    end

    def self.save_svg_figure(x, y, path = "figures/figure.svg", config = nil)
      graph = config.nil? ? init_with_x_y(x, y) : init_with_x_y(x, y, config)
      File.open(path, "w") { |f| f.write(graph.burn_svg_only) }
    end
  end
end
