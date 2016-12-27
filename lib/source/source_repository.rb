module Semble
  module Source
    class SourceRepository

      def initialize
        @map = { default: [] }
      end

      def push(layer)
        @map[layer.platform] = [] unless @map.has_key?(layer.platform)
        @map[layer.platform].push(layer)
        @map[layer.platform].sort! { |a, b| a.version <=> b.version }
      end

      def get_slice(platform, version)
        (@map[platform] or []).select do |layer|
          layer.version <= version
        end
      end
    end
  end
end