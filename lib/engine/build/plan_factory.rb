require 'logging/logger_factory'

module Semble
  module API
    module Build
      class PlanFactory
        def initialize(schema)
          @schema = schema
          @logger = Semble::Logging::LoggerFactory.get
        end

        def create_mirror_plan(mirror_request)

        end

        def create_build_plan(build_request)

        end
      end
    end
  end
end