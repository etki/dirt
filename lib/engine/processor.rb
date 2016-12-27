require 'source/layer_reducer'

module Semble
  module Engine
    class Processor
      attr_accessor :sources
      attr_accessor :renderer
      attr_accessor
      
      def initialize
        @reducer = Semble::Source::LayerReducer.new
      end

      def process(platform, version)
        source_files = @reducer.reduce(sources.get_slice(platform, version))
        entries = source_files.values.map do |source|
          if source.type == :template

          end
        end
      end

      def reduce_layers(layers)

      end

    end
  end
end