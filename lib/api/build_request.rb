module Semble
  module API
    class BuildRequest
      attr_accessor :image_id
      attr_accessor :context

      def initialize(image_id, context = {}, &block)
        @image_id = image_id
        @context = context
        block.call(self)
      end
    end
  end
end