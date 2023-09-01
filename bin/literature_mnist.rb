file = File.readlines("data/mnist_train.csv")

# first simualate the csv with some less data

floats = file.map { |line| line.chomp.split(",") }.map { |line| line.map(&:to_i) }.sample(100)
# pp floats

data = floats.map do |line|
  [line[0]] + line[1..-1].each_with_index.map do |item, index|
                item != 0.0 ? index : -1
              end.filter { |x| x != -1 }
end
# p data
# p data.group_by{|line| line[0]}[8.0]
p data.group_by(&:shift)
