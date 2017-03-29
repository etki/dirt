require 'logger'
require 'pathname'

module Semble
  module Configuration
    module Constants
      DEFAULT_PLATFORMS = ['_default']
      DEFAULT_SOURCE_DIRECTORIES = [Pathname.new('src')]
      DEFAULT_OUTPUT_DIRECTORY = Pathname.new('build')
      DEFAULT_LOG_THRESHOLD = Logger::INFO
      SHORT_VERSION_STRATEGY_NONE = :none
      SHORT_VERSION_STRATEGY_LATEST = :latest
      DEFAULT_SHORT_VERSION_STRATEGY = SHORT_VERSION_STRATEGY_NONE
    end
  end
end