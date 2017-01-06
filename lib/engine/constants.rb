require 'pathname'

module Semble
  module Engine
    module Constants
      SHORT_VERSION_STRATEGY_NONE = :none
      # noinspection RubyConstantNamingConvention
      SHORT_VERSION_STRATEGY_EARLIEST = :earliest
      SHORT_VERSION_STRATEGY_LATEST = :latest
      SHORT_VERSION_STRATEGIES = [
          SHORT_VERSION_STRATEGY_NONE,
          SHORT_VERSION_STRATEGY_EARLIEST,
          SHORT_VERSION_STRATEGY_LATEST,
      ]
      DEFAULT_SHORT_VERSION_STRATEGY = SHORT_VERSION_STRATEGY_NONE

      LOGGER_THRESHOLD_DEBUG = :debug
      LOGGER_THRESHOLD_INFO = :info
      LOGGER_THRESHOLD_WARN = :warn
      LOGGER_THRESHOLD_ERROR = :error
      LOGGER_THRESHOLDS = [
          LOGGER_THRESHOLD_DEBUG,
          LOGGER_THRESHOLD_INFO,
          LOGGER_THRESHOLD_WARN,
          LOGGER_THRESHOLD_ERROR
      ]
      DEFAULT_LOGGER_THRESHOLD = LOGGER_THRESHOLD_INFO

      DEFAULT_SOURCES_DIRECTORY = 'src'
      DEFAULT_OUTPUT_DIRECTORY = 'build'

      DEFAULT_PLATFORMS = [:_default]

      WHITEOUT_PREFIX = '.wh.'

      TEMPLATE_EXTENSIONS = %w(.liquid .twig)

      SOURCE_SET_CONFIG_DIRECTORY = Pathname.new('.semble')
      SOURCE_SET_CONTEXT_FILE_NAME = Pathname.new('context.yml')
    end
  end
end