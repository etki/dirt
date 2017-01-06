module Semble
  module Model
    module Blueprints
      class Target
        # @!attribute [rw] id
        #   @return [Semble::Model::Id]
        attr_accessor :id
        # @!attribute [rw] context
        #   @return [Hash]
        attr_accessor :context

        def to_s
          "Target version `#{id}`, context size: #{context.size}"
        end
      end
    end
  end
end