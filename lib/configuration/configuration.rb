module Semble
  module Configuration

    DEFAULT_SOURCES_PATH = 'src'
    DEFAULT_OUTPUT_PATH = 'build'
    SHORT_VERSION_STRATEGY_NONE = :none
    SHORT_VERSION_STRATEGY_LATEST = :latest

    class Configuration
      attr_accessor :structure
      attr_accessor :schema
      attr_accessor :short_version_strategy
      attr_accessor :default_platform

      def initialize(&block)
        block.call(self) if block
      end
    end

    class StructureConfiguration
      attr_accessor :sources
      attr_accessor :output

      def initialize(sources = nil, output = nil, &block)
        @sources = sources
        @output = output
        block.call(self) if block
      end
    end

    class VersionConfiguration
      attr_accessor :version
      attr_accessor :context

      def initialize(version = nil, context = {}, &block)
        @version = version
        @context = context
        block.call(self) if block
      end
    end
  end
end