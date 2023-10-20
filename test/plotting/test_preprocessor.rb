# frozen_string_literal: true

require "bundler"
Bundler.require(:test)

require "test_helper"
require "plotting/preprocessor"
class Plotting::TestPlotter < Minitest::Test
  include Plotting::Preprocessor
  def test_prepare_line_coords
    range = [0..5, 1..3]
    split_point = Data.define(:split_point, :dimension).new(2, 0)

    res = prepare_line_coords_general(range, split_point) { |min, max| gaperize_min_max(min, max, 0.0) }

    assert_equal([[2, 1], [2, 3]], res)
  end
end
