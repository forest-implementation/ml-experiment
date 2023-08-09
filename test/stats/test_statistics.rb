# frozen_string_literal: true
require "bundler"
Bundler.require(:test)

require "test_helper"
require "stats/statistics"
class Stats::TestStatistics < Minitest::Test
  include Stats::Statistics
  
  def test_column_minmax
    input = [[1],[5],[2],[3]]
    index = 0
    assert_equal (1..5), column_minmax(input, index)
  end

  def test_quantil_int
    sorted = [1,2,3,4,5,6,7]
    assert_equal 2.5, quantil(sorted, 0.25)
    assert_equal 5.5, quantil(sorted, 0.75)
  end
  
  def test_quantil
    sorted = [1,2,3,4,5,6,7,8]
    assert_equal 2.75, quantil(sorted, 0.25)
    assert_equal 6.25, quantil(sorted, 0.75)
  end

  def test_median
    assert_equal median([1,2,3,4,5,6,7]), 4 
  end
  
  def test_fast_medcouple
    assert_in_delta 0.286, fast_medcouple([1,2,3,4,7,8])
    assert_equal 0.0, fast_medcouple([1,2,3,4,5,6])
    assert_equal 0.0, fast_medcouple([1,2,3,4,5])
  end
  
  def test_naive_medcouple
    assert_in_delta 0.286, naive_medcouple([1,2,3,4,7,8])
    assert_equal 0.0, naive_medcouple([1,2,3,4,5,6])
    assert_equal 0.0, naive_medcouple([1,2,3,4,5])
    assert_in_delta 1/6.0, naive_medcouple([1,2,3,4,2].sort)
  end

  def test_sgn
    assert_equal -1, sgn(-12)
    assert_equal 0, sgn(0)
    assert_equal 1, sgn(0.1)
  end

  def test_adujted_box
    assert_equal (2.5-4.5)..(5.5+4.5), adjusted_box([[1],[2],[3],[4],[5],[6],[7]], 0)
  end

  def test_weighted_median
    assert_equal 4, weighted_median([1,2,3,4, 5],[0.15,0.1,0.2,0.3,0.25])
    assert_equal 2.5, weighted_median([1,2,3,4],[0.25,0.25,0.25,0.25])
    assert_equal 2.5, weighted_median([1,2,3,4],[0.49,0.01,0.25,0.25])
    
  end

  def test_scanl
    arr = [1,2,3,4]
    assert_equal scanl(arr) {|x,y| x + y}.to_a, [1,3,6,10]
    
  end

  def test_r_medcouple_16
    arr = [4,3,2,2,1]
    assert_in_delta 1/6.0, r_medcouple(arr)
  end

  def test_r_medocouple_zero
    arr = [1,2,3,4,5]
    assert_equal 0, r_medcouple(arr)
  end

  def test_r_medcouple_another
    arr = [4,3,2,2,1,4,2]
    assert_in_delta 2/3.0, r_medcouple(arr)
  end
  
end
