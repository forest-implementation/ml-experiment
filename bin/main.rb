# frozen_string_literal: true

require "bundler/setup"

require 'svggraph' # https://github.com/lumean/svg-graph2

require 'SVG/Graph/Plot'

require 'rubystats'


norm = Rubystats::NormalDistribution.new(0.0, 1.0)
actual_y = 100.times.map { |_| norm.rng }
actual_x = (0...100).to_a


projection_y = 100.times.map { |_| norm.rng }
projection_x = (0...100).to_a

actual = actual_x.zip(actual_y)
projection = projection_x.zip(projection_y)


class SVG::Graph::Plot < SVG::Graph::Graph
  def initialize( config )
    @add_popups = false

    @config = config
    # array of Hash
    @data = []
    #self.top_align = self.top_font = 0
    #self.right_align = self.right_font = 0

    init_with({
                :width                => 500,
                :height               => 300,
                :show_x_guidelines    => false,
                :show_y_guidelines    => true,
                :show_data_values     => false,

                :x_axis_position      => nil,
                :y_axis_position      => nil,

                :min_scale_value      => nil,

                :show_x_labels        => true,
                :stagger_x_labels     => false,
                :rotate_x_labels      => false,
                :step_x_labels        => 1,
                :step_include_first_x_label => true,

                :show_y_labels        => true,
                :rotate_y_labels      => false,
                :stagger_y_labels     => false,
                :scale_integers       => false,

                :show_x_title         => true,
                :x_title              => 'X Field names',
                :x_title_location     => :middle,  # or :end

                :show_y_title         => true,
                :y_title_text_direction => :bt,  # other option is :tb
                :y_title              => 'Y Scale',
                :y_title_location     => :middle,  # or :end

                :show_graph_title      => false,
                :graph_title          => 'Graph Title',
                :show_graph_subtitle  => false,
                :graph_subtitle        => 'Graph Sub Title',
                :key                  => true,
                :key_width             => nil,
                :key_position          => :right, # bottom or right

                :font_size            => 12,
                :title_font_size      => 16,
                :subtitle_font_size   => 14,
                :x_label_font_size    => 12,
                :y_label_font_size    => 12,
                :x_title_font_size    => 14,
                :y_title_font_size    => 14,
                :key_font_size        => 10,
                :key_box_size         => 12,
                :key_spacing          => 5,

                :no_css               => false,
                :add_popups           => false,
                :popup_radius         => 10,
                :number_format        => '%.2f',
                :style_sheet          => '',
                :inline_style_sheet   => ''
              })

    # override default values with user supplied values
    init_with config
  end
end

graph_immutable = SVG::Graph::Plot.new({
                                         :height => 300,
                                         :width => 500,
                                         #:key => true,
                                         :scale_x_integers => true,
                                         :scale_y_integers => true ,
                                         :show_data_points => false,
                                         :show_lines => true,
                                       })




graph_immutable.add_data({
                           :data => actual,
                           :title => 'actual'
                         })

graph_immutable.add_data({
                           :data => projection,
                           :title => 'projected'
                         })

print "Content-type: image/svg+xml\r\n\r\n";
File.open('figures/bar.svg', 'w') { |f| f.write(graph_immutable.burn_svg_only) }


