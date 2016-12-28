module Semble
  module Model
    class VersionSpecification
      include Comparable

      # @type [String]
      attr_accessor :platform
      # @type [Semble::Model::Version]
      attr_accessor :version
      # @type [Hash{Pathname => Semble::Model::FileSource}]
      attr_accessor :sources
      attr_accessor :context

      def initialize(&block)
        @sources = {}
        @context = {}
        block.call(self) if block
      end

      def merge(other)
        result = clone
        result.platform = other.platform
        result.version = other.version
        result.sources = Semble::Utility::Hash.deep_merge(result.sources, other.sources)
        result.context = Semble::Utility::Hash.deep_merge(result.context, other.context)
      end

      def <=>(other)
        version <=> other.version
      end
    end
  end
end