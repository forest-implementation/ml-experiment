require "ruby-graphviz"

module Plotting
  module Graphviz
    # for auto mapping options keys to string
    def hash_to_s(inhash)
      inhash.map { |key, val| "#{key}: #{val}\n" }.join
    end

    # monkey patch add edges so it allows for SP and D labeling
    # labels can be any hash of key values, using hash_to_s function it will be converted to string
    class MujGraphViz < GraphViz
      def add_edges(node_one, node_two, options = {}, labels = {}, depth)
        if node_one.instance_of?(Array)
          node_one.each do |no|
            add_edges(no, node_two, options, labels, depth)
          end
        elsif node_two.instance_of?(Array)
          node_two.each do |nt|
            add_edges(node_one, nt, options, labels, depth)
          end
        else
          edge = GraphViz::Edge.new(node_one, node_two, self)
          xnode = get_node(node_one)
          ynode = get_node(node_two)
          xnode["label"] = "#{node_one}\n#{hash_to_s(labels)}"
          pp "deprth je#{depth}"
          ynode["label"] = "#{node_two}\npath_length: #{depth.round(2)}"
          edge.index = @elements_order.size_of("edge")

          options.each do |xKey, xValue|
            edge[xKey.to_s] = xValue
          end

          @elements_order.push({
                                 "type" => "edge",
                                 "value" => edge
                               })
          @loEdges.push(edge)

          edge
        end
      end
    end

    # Create a new edge
    # input = array of hashed node parent to hashed nodes children
    # example: ["parent", ["child1", "child2"]
    def create_graph(input, rankdir = "LR")
      g = MujGraphViz.new(:G, type: :digraph, "rankdir" => rankdir)
      g.node[:shape] = "polygon"
      input.each do |x, y, data, depth|
        g.add_edges(x, y, {}, { sp: data.split_point.round(2), dim: data.dimension}, depth)
      end
      g
    end

    def save_graph(graph_object, path)
      graph_object.output(svg: path)
    end
  end
end
