require "plotting/gnuplotter"
include Plotting::Gnuplotter

plot do |x|
  # x.data << points_init([2,3], [1,2])
  # x.data << points_init([1, 2, 3], [3, 2, 1])
  x.data << points_init([2], [2])
  x.data << lines_init([1, 3], [1, 10])
  x.data << lines_init([1, 2.5], [2, 3])
  x.label = labels_init([2], [2])
end
