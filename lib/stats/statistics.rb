require 'enumerable/statistics'

require "matrix"
require "rinruby"

module Stats
  module Statistics
    
    def scanl(elem,start: 0,&op)
      Enumerator.new do |yielder|
        acc = start
          elem.each do |x|
            acc = op.call(acc, x)
            yielder << acc
        end
      end.lazy
    end
        
    def column_minmax(input, index)
      min, max = input.map { |x| x[index] }.minmax
      (min..max)
    end

    def quantil(sorted, p = 0.25)
      # h = (sorted.length + 1)*p - 1
      # sorted[h.floor] + (h - h.floor) * (sorted[h.ceil] - sorted[h.floor])
      sorted.percentile p * 100
    end
  
    def column_deviation(input, index)
      sorted = input.map { |x| x[index] }.sort
      fqr, tqr = quantil(sorted, 0.25), quantil(sorted, 0.75)
      iqr = tqr - fqr
      (fqr - 1.5 * iqr)..(tqr + 1.5 * iqr)
    end


    def median(sorted)
      sorted.median
    end

    # raise "median test failed" unless median([1,2,3,4,5]) == 3 
    # raise "median test failed" unless median([1,2,3,4]) == 2.5 

    def sgn(x)
      x <=> 0
    end

    def h_index(i,j, zplus,zminus, p)
      a = zplus[i]
      b = zminus[j]
      a == b ? sgn(p - 1 - i - j): (a+b)/(a-b)
    end

    def divide_z(sorted_arr)
      reversed = sorted_arr.reverse

      xm = median(sorted_arr)
      xscale = 2* reversed.map(&:abs).max
      zplus = reversed.filter { |x| x >= xm }.map { |x| (x-xm)/xscale.to_f }
      zminus = reversed.filter { |x| x <= xm }.map { |x| (x-xm)/xscale.to_f }
      return zplus, zminus
    end

    def naive_medcouple(sorted_arr)
      zplus, zminus = divide_z(sorted_arr)
      p = zplus.size
      q = zminus.size
      first = (0..p-1)
      second = (0..q-1)
      h_value = first.to_a.product(second.to_a).map { | x,y | h_index(x,y, zplus, zminus, p)}
      median(h_value.sort)
    end

    def weighted_median(row_medians, weights)
      half = weights.sum/2.0
      rindex = scanl(weights) { |x,y| x + y }.find_index{ |x| x > half }
      lindex = scanl(weights) { |x,y| x + y }.find_index{ |x| x >= half }
      (row_medians[lindex] + row_medians[rindex]) / 2.0
    end

    def greater_h(kernel_h, p, q, u)
      
    end

    def less_h(kernel_h, p, q, u)
    end

    def medcouple_iteration(left, right, r_total: 0, l_total: 0, p: 0, q: 0, zplus: [], zminus: [])
      middle_idx = (0...p).filter{|i| left[i] <= right[i]}
      row_medians = middle_idx.map {|i| h_index(i, (left[i] + right[i])/2, zplus, zminus, p)}
      weights = middle_idx.map { |x| right[i] - left[i] + 1}
      weighted_median = weighted_median(row_medians, weights)
      # TODO: continue here
      
    end

    def fast_medcouple(arr)
      zplus, zminus = divide_z(sorted_arr)
      p = zplus.size
      q = zminus.size
      left = Array.new(p, 0)
      right = Array.new(p, q-1)
      l_total = 0
      r_total = p * q
      medcouple_index = (r_total / 2)
    end

    def r_medcouple(arr)
    
      R.arr = arr
      R.eval <<EOF
          library(robustbase)
          res <- mc(arr)
EOF
      R.res
    end

    def adjusted_box(input, index)
      s = input.map { |x| x[index] }
      sorted = s.sort
      fqr, tqr = quantil(sorted, 0.25), quantil(sorted, 0.75)
      iqr = tqr - fqr
      med = r_medcouple(sorted)
      pp "medoucple #{med}"
      return  (fqr - 1.5*iqr* Math::E ** (-4*med))..(tqr + 1.5*iqr*Math::E ** (3*med)) if med >= 0
      return (fqr - 1.5*iqr* Math::E ** (-3*med))..(tqr + 1.5*iqr*Math::E ** (4*med)) if med <= 0
    end

  end
end
