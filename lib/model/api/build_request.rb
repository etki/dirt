module Semble
  module Model
    module API
      class BuildRequest
        # @!attribute [rw] id
        #   @return [Semble::Model::Id]
        attr_accessor :id
        # @!attribute [rw] context
        #   @return [Hash]
        attr_accessor :context
      end
    end
  end
end