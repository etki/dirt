module Semble
  module Model
    class VersionSpecification
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
    end
  end
end