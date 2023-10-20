module Plotting
  module Preprocessor
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
