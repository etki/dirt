require 'logger'

module Semble
  module Logging
    class LoggerFactory

      attr_accessor :target
      attr_accessor :threshold

      def initialize(target = STDOUT, threshold = Logger::INFO)
        self.target = target
        self.threshold = threshold
      end

      def get(name = nil, threshold = nil, target = nil)
        logger = Logger.new((target or self.target))
        logger.level = (threshold or self.threshold)
        logger
      end

      @@singleton = self.new

      def self.threshold=(threshold)
        @@singleton.threshold = threshold
      end

      def self.target=(target)
        @@singleton.target = target
      end

      def self.get(name = nil, threshold = nil, target = nil)
        @@singleton.get(name, threshold, target)
      end
    end
  end
end