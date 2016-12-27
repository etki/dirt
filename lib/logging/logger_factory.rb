require 'logger'

module Semble
  module Logging
    class LoggerFactory

      @@sink = STDOUT
      @@level = Logger::INFO

      def self.set_level(level)
        @@level = level
      end

      def self.set_sink(sink)
        @@sink = sink
      end

      def self.get
        logger = Logger.new(sink)
        logger.level = @@level
        logger
      end
    end
  end
end