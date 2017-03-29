require_relative 'constants'
require_relative '../model/configuration/configuration'

module Semble
  module Configuration
    class DefaultConfiguration < ::Semble::Model::Configuration::Configuration
      include Constants

      def source_directories
        [DEFAULT_SOURCE_DIRECTORIES]
      end

      def output_directory
        DEFAULT_OUTPUT_DIRECTORY
      end

      def schema
        nil
      end

      def short_version_strategy
        DEFAULT_SHORT_VERSION_STRATEGY
      end

      def default_platforms
        DEFAULT_PLATFORMS
      end

      def working_directory
        Dir.pwd
      end

      def log_threshold
        DEFAULT_LOG_THRESHOLD
      end

      def log_target
        $stdout
      end
    end
  end
end