module Ml
  module Experiment
    class Preprocessor
      def self.filter_normal(data)
        data.filter { |datapoint| datapoint[-2] == "0" }.map do |x|
          x[0..-3].map(&:to_f)
        end
      end

      def self.filter_outliers(data)
        data.filter { |datapoint| datapoint[-2] == "1" }.map do |x|
          x[0..-3].map(&:to_f)
        end
      end
    end
  end
end