require "ruby-graphviz"

module Plotting
  module Graphviz
    # for auto mapping options keys to string
    def hash_to_s(inhash)
      inhash.map { |key, val| "#{key}: #{val}\n" }.join
    end

    # Create a new edge
    # input = array of hashed node parent to hashed nodes children
    # example: ["parent", ["child1", "child2"]
    def create_graph(nodes, edges, rankdir = "TB")
      g = GraphViz.new(:G, type: :digraph, "rankdir" => rankdir)
      g.node[:shape] = "rectangle"
      nodes.each do |x, label|
        g.add_nodes(x.to_s, { label: hash_to_s(label[:label]) })
      end
      edges.each do |x, y|
        g.add_edges(x.to_s, y.map(&:to_s), {})
      end
      g
    end

    def save_graph(graph_object, path)
      graph_object.output(svg: path)
    end
  end
end
