require "ruby-graphviz"

# Create a new graph
g = GraphViz.new(:G, type: :digraph)

# Create two nodes
# hello = g.add_nodes("Hello")
# world = g.add_nodes("World")

# Create an edge between the two nodes
g.add_edges("hello", %w[fds nazdar])
g.add_edges("hello", "ahoj")

# Generate output image
g.output(svg: "figures/hello_world.svg")
