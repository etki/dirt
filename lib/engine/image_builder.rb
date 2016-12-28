require 'model/version_image'
require 'utility/hash'

module Semble
  module Engine
    # This class is used to squash set of versions into one, allowing
    # to compute final image for particular version
    class ImageBuilder
      # @param [Array<Semble::Model::VersionSpecification>] sources
      # @return [Semble::Model::VersionSpecification]
      def build(sources, platform = nil, version = nil, context = {})
        image = Semble::Model::VersionImage.new
        image.context = {}
        image.sources = {}

        last_version = nil
        last_platform = nil
        # @param [Semble::Model::VersionSpecification]
        sources.each do |specification|
          last_version = specification.version
          last_platform = specification.platform
          image.context = Semble::Utility::Hash.deep_merge(image.context, specification.context)
          image.sources = Semble::Utility::Hash.deep_merge(image.sources, specification.sources)
        end
        image.platform = (platform or last_platform)
        image.version = (version or last_version)
        image.context = Semble::Utility::Hash.deep_merge(image.context, context)
        image
      end
    end
  end
end