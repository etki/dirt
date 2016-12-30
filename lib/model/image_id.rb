module Semble
  module Model
    class ImageId
      attr_accessor :platform
      attr_accessor :version

      def initialize(platform = nil, version = nil, &block)
        @platform = platform
        @version = version
        block.call(self) if block
      end

      def to_s
        "#{platform}:#{version}"
      end
    end
  end
end