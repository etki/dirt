module Semble
  module Model
    # This class represents resulting version image - a set of files sources
    # and context that may be used to produce resulting file set.
    class VersionImage
      attr_accessor :platform
      attr_accessor :version
      attr_accessor :sources
      attr_accessor :context

      def initialize(&block)
        @sources = {}
        @context = {}
        block.call(self) if block
      end
    end
  end
end