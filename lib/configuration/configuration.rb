module Semble
  module Configuration
    class Configuration
      attr_accessor :semble
      attr_accessor :context
      attr_accessor :schema
    end

    class SembleConfiguration
      attr_accessor :short_version_strategy
      attr_accessor :default_platform
    end

    class StructureConfiguration
      attr_accessor :sources
      attr_accessor :output
    end

    class VersionConfiguration
      attr_accessor :version
      attr_accessor :context

      def initialize(version = nil, context = {})
        @version = version
        @context = context
      end
    end

    class PlatformConfiguration
      attr_accessor :platform
      attr_accessor :versions
      attr_accessor :context

      def initialize(platform = nil, versions = {}, context = {})
        @platform = platform
        @versions = versions
        @context = context
      end
    end
  end
end