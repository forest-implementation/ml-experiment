require "ruby-graphviz"

module Plotting
  module Graphviz
    # input = array of hashed node parent to hashed nodes children
    # example: ["parent", ["child1", "child2"]
    def create_graph(input, rankdir = "LR")
      g = GraphViz.new(:G, type: :digraph, "rankdir" => rankdir)
      g.node[:shape] = "polygon"
      input.each do |x, y|
        g.add_edges(x, y)
      end
      g
    end

    def save_graph(graph_object, path)
      graph_object.output(svg: path)
    end
  end
end
