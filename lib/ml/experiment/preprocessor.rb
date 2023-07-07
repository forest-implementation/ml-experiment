module Ml
  module Experiment
    class Preprocessor
      def self.filter_normal(data)
        data.filter { |datapoint| datapoint[-1] == "1" }.map do |x|
          x[0...-1].map(&:to_f)
        end
      end

      def self.filter_outliers(data)
        data.filter { |datapoint| datapoint[-1] == "2" }.map do |x|
          x[0...-1].map(&:to_f)
        end
      end
    end
  end
end