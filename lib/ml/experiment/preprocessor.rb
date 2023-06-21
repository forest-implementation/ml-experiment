module Ml
  module Experiment
    class Preprocessor
      def self.filter_normal(data)
        data.filter { |datapoint| datapoint[-1] == "'no'" }.map do |x|
          x[0..-3].map(&:to_f)
        end
      end

      def self.filter_outliers(data)
        data.filter { |datapoint| datapoint[-1] == "'yes'" }.map do |x|
          x[0..-3].map(&:to_f)
        end
      end
    end
  end
end