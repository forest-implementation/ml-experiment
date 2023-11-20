module Plotting
  module Preprocessor
    def nicekey(hnuskey)
      hnuskey = hnuskey.map(&:minmax).map{|y| y.map{|x| x.round(2)}}
      "#{hnuskey[0]}\n#{hnuskey[1]}"
    end

    # for outlier plotting
    def rectangles_coords(tree, &fun)
      if tree.is_a?(Node::OutNode)
        return fun.call({ "borders" => tree.minmaxborders,
                          "depth" => tree.data.depth + Evaluatable.evaluate_path_length_c(tree.data.data.size) })
      end
    
      fun.call({ "borders" => tree.minmaxborders, "depth" => -1 })
      tree.branches.map { |_key, x| rectangles_coords(x) { |x| fun.call x } }
    end

    # for graphviz novelty depths plotting
    def deep_depths(key, tree, &fun)
      return if tree.is_a?(Node::OutNode)

      fun.call [nicekey(key), tree.branches.keys.map { |kk| nicekey(kk) }] if tree.is_a?(Node::InNode)
      tree.branches.map do |key, x|
        deep_depths(key, x) { |x| fun.call x }
      end
    end


    # TODO: NEFUNGUJE
    def rectangles_coords_deep(key, tree, &fun)
      return if tree.is_a?(Node::OutNode)
    pp tree.branches.keys
    fun.call [nicekey(key), tree.branches.keys.map { |kk| nicekey(kk) }] if tree.is_a?(Node::InNode)
      tree.branches.map do |key, y|
        rectangles_coords_deep(key,y) { |x| fun.call x }
      end
    end

    # for labels in the middle of the novelty node
    def prepare_depth_labels(split_depths_array)
      split_depths_array.map do |ranges, depth|
        x = ranges[0].minmax.sum / 2.0
        y = ranges[1].minmax.sum / 2.0
        [depth.round(2), x, y]
      end
    end

    def split_and_depths(key, tree, &fun)
      if tree.is_a?(Node::OutNode)
        return fun.call [key, tree.data.depth + Evaluatable.evaluate_path_length_c(tree.data.data.size)]
      end

      tree.branches.map { |key, x| split_and_depths(key, x) { |x| fun.call x } }
    end

    def splitpoints(key, tree, &fun)
      return [key, tree.data.depth] if tree.is_a?(Node::OutNode)

      fun.call [key, tree.split_point]
      tree.branches.map { |key, x| splitpoints(key, x) { |x| fun.call x } }
    end

    # this function is for making a nice 3D plasticity effect for lines
    def gaperize_min_max(min, max, percent = 0.02)
      [min + (max - min) * percent, max - (max - min) * percent]
    end

    def prepare_line_coords_general(range, split_point)
      yield(*range[1 - split_point.dimension].minmax).map do |x|
        split_point.dimension == 1 ? [x, split_point.split_point] : [split_point.split_point, x]
      end
    end

    # input: [x1..y1, x2..y2], SplitPointD(split_point=R from [x1..y1] | [x2..y2], dimension=0|1)
    # TODO: For now, only 2 dimensions are supported (x,y)
    def prepare_line_coords(range, split_point)
      prepare_line_coords_general(range, split_point) { |min, max| gaperize_min_max(min, max) }
    end

    # input: array of prepare_line_coords's inputs
    def prepare_lines_coords(range_split_points)
      lines_coords = range_split_points.map do |range, split_point|
        prepare_line_coords(range, split_point)
      end
      lines_coords.flatten(1).transpose
    end

    # prepares array of x's and y's for plotting
    # returns a tuple
    # 1. x's values of lines
    # 2. y's values of lines
    def prepare_lines(ranges, forest)
      range_split_points = Enumerator.new do |y|
        splitpoints(ranges, forest.trees[0]) { |x| y << x }
      end
      prepare_lines_coords(range_split_points)
    end

    # inserts "" after every two xs to make the plotter noncontinuous
    def prepare_for_lines_plot(points_of_one_d)
      points_of_one_d.enum_for(:each_slice, 2).map { |tuple| [tuple, ""] }.flatten(2)
    end
  end
end
