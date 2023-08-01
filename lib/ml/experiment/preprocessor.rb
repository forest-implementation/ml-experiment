module Ml
  module Experiment
    class Preprocessor
      def self.filter_normal(data, normal_class: "0")
        data.filter { |datapoint| datapoint[-1] == normal_class }.map do |x|
          x[0...-1].map(&:to_f)
        end
      end

      def self.filter_outliers(data, normal_class: "0")
        data.filter { |datapoint| datapoint[-1] != normal_class }.map do |x|
          x[0...-1].map(&:to_f)
        end
      end
    end
  end
end