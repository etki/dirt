module Semble
  module Model
    class Id
      include Comparable

      attr_accessor :platform
      attr_accessor :version

      def initialize(platform = nil, version = nil)
        self.platform = platform
        self.version = version
      end

      def to_s
        "#{platform}:#{version}"
      end

      def <=>(other)
        version <=> other.version
      end
    end
  end
end