module Semble
  module Model
    module API
      class BuildReport
        attr_accessor :image_id
        attr_accessor :success
        # :compute or :mirror
        attr_accessor :build_type
        attr_accessor :exception

        def initialize(platform = nil, version = nil, type = :compute, &block)
          @platform = platform
          @version = version
          @build_type = type
          block.call(self) if block
        end

        def complete
          @success = true
          @exception = nil
          self
        end

        def abort(exception)
          @success = false
          @exception = exception
          self
        end
      end
    end
  end
end