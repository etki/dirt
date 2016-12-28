module Semble
  module Model
    class FileSource
      # @!attribute [rw] path
      #   @return [Pathname]
      attr_accessor :path
      # @!attribute [rw] origin
      #   @return [Origin]
      attr_accessor :origin
      # @!attribute [rw] type
      #   @return [Symbol] :unknown or :template
      attr_accessor :type

      def initialize(&block)
        block.call(self) if block
      end

      class Origin
        attr_accessor :platform
        attr_accessor :version
        attr_accessor :path

        def initialize(&block)
          block.call(self) if block
        end
      end
    end
  end
end