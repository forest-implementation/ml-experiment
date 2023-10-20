# frozen_string_literal: true

require "bundler"
Bundler.require(:test)

require "test_helper"
require "plotting/gnuplotter"
class Plotting::TestGnuPlotter < Minitest::Test
  include Plotting::Gnuplotter
  def test_rect_inside
    out_rect = [[17.7, 3.8], [20.9, 6.05]]
    in_rect = [[17.7 + 1, 3.8 + 1], [20.9 - 1, 6.05 - 1]]
    assert(rect_inside?(out_rect, in_rect))
  end
end
