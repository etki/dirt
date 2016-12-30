module Semble
  module Configuration
    class Configuration
      include Semble::Configuration::Constants

      attr_accessor :structure
      attr_accessor :schema
      attr_accessor :short_version_strategy
      attr_accessor :default_platforms

      def initialize(&block)
        @schema = {}
        @short_version_strategy = SHORT_VERSION_STRATEGY_NONE
        @default_platforms = DEFAULT_PLATFORMS
        block.call(self) if block
      end

      def self.default(working_directory = nil)
        working_directory = (working_directory or Dir.pwd)
        Configuration.new do |c|
          c.structure = StructureConfiguration.new do |sc|
            sc.sources = File.join(working_directory, DEFAULT_SOURCES_PATH)
            sc.output = File.join(working_directory, DEFAULT_OUTPUT_PATH)
          end
        end
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