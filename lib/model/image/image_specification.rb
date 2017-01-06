module Semble
  module Model
    module Image
      class ImageSpecification
        # @type [Semble::Model::Id]
        attr_accessor :id
        # @type [Hash<Pathname, Semble::Model::Blueprints::FileSource>]
        attr_accessor :sources
        # @type [Hash]
        attr_accessor :context
      end
    end
  end
end