module Semble
  module API
    class MirrorRequest
      attr_accessor :source_platform
      attr_accessor :source_version
      attr_accessor :target_platform
      attr_accessor :target_version

      def initialize(source_platform = nil, source_version = nil, target_platform = nil, target_version = nil, &block)
        @source_platform = source_platform
        @source_version = source_version
        @target_platform = target_platform
        @target_version = target_version
        block.call(self) if block
      end
    end
  end
end