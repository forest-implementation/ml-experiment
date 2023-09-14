# frozen_string_literal: true

require "bundler"
Bundler.require(:test)

require "test_helper"
require "plotting/plotter"
class Plotting::TestPlotter < Minitest::Test
  def test_calc_coords_pub
    res1 = SVG::Graph::Plot.new({}).calc_coords_pub([9.0, 3.0], 0, 10, 2, 7)
    pp res2 = SVG::Graph::Plot.new({}).calc_coords_pub([15.65, 3.0], -5.815856182897736, 22.77017597837832, 2, 7)
    pp res3 = SVG::Graph::Plot.new({}).calc_coords_pub([15.85, 3.0], -5.815856182897736, 22.77017597837832, 0, 7)

    assert_equal({ x: 328.5, y: 200.0 }, res1)
    assert_equal({ x: 328.5, y: 200.0 }, res2)
    assert_equal({ x: 328.5, y: 200.0 }, res1)
  end
end
