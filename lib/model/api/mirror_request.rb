module Semble
  module Model
    module API
      class MirrorRequest
        # @!attribute [rw] source
        #   @return [Semble::Model::Id]
        attr_accessor :source
        # @!attribute [rw] target
        #   @return [Semble::Model::Id]
        attr_accessor :target
      end
    end
  end
end