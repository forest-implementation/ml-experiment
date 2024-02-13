require "bundler/setup"

require "rubygems"
require "csv"
require "ml/service/isolation/novelty"
require "ml/forest"
require "plotting/gnuplotter"
require "net/http"
require "plotting/preprocessor"

include Plotting::Gnuplotter
include Plotting::Preprocessor

trainData = CSV.parse(
  Net::HTTP.get(
    URI("https://raw.githubusercontent.com/chazzka/novelties_datasets/main/clicked/csv/data_novelties_clicked_train.csv")
  ), headers: false, converters: %i[numeric]
).map do |x|
  [x[0], x[1]]
end

testData = CSV.parse(
  Net::HTTP.get(
    URI("https://raw.githubusercontent.com/chazzka/novelties_datasets/main/clicked/csv/data_novelties_clicked_test.csv")
  ), headers: false, converters: %i[numeric]
).map do |x|
  [x[0], x[1]]
end

ranges = [-50..800, 0..500]
novelty_service = Ml::Service::Isolation::Novelty.new(batch_size: 30, max_depth: 5, ranges: ranges)
# FILTER OUT inputs out of range!
trainData = trainData.filter { |input| ranges[0].include?(input[0]) && ranges[1].include?(input[1]) }

forest = Ml::Forest::Tree.new(trainData, trees_count: 1, forest_helper: novelty_service)

pred_input = testData.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }

plot_regular = testData.zip(pred_input).filter { |_coord, score| !score.novelty? }.map { |x| x[0] } + trainData
plot_novelty = testData.zip(pred_input).filter { |_coord, score| score.novelty? }.map { |x| x[0] }

r = prepare_lines(ranges, forest)

s = Enumerator.new do |y|
  split_and_depths(ranges, forest.trees[0]) { |x| y << x }
end

labels, label_xs, label_ys = prepare_depth_labels(s).transpose

Gnuplot.open do |gp|
  plot(gp, "../../figures/exper.svg", ranges[0].minmax, ranges[1].minmax, "right") do |plot|
    plot.data << lines_init(prepare_for_lines_plot(r[0]),
                            prepare_for_lines_plot(r[1]))
    plot.data << points_init(*plot_regular.transpose, "regular", "1", "black") # regular
    plot.data << points_init(*plot_novelty.transpose, "anomaly", "2", "blue") # novelty
    # set_labels(plot, %w[Px B], [15 - 1, 7], [2.5 + 0.1, 7], style = "Bold")
    set_labels(plot, labels, label_xs, label_ys)
  end
end
