require 'model/version_specification'
require 'utility/hash'

module Semble
  module Engine
    # This class is used to squash set of versions into one, allowing
    # to compute final image for particular version
    class VersionReducer

      # @param [Array<Semble::Model::VersionSpecification>] versions
      # @return [Semble::Model::VersionSpecification]
      def reduce(*versions)
        if not versions or versions.empty?
          raise ArgumentError, 'Empty version list passed'
        end

        squashed = Semble::Model::VersionSpecification.new
        squashed.context = {}
        # @param [Semble::Model::VersionSpecification]
        versions.each do |specification|
          squashed.version = specification.version
          squashed.platform = specification.platform
          squashed.context = Semble::Utility::Hash.deep_merge(squashed.context, specification.context)
          squashed.sources = Semble::Utility::Hash.deep_merge(squashed.sources, specification.sources)
        end
        squashed
      end
    end
  end
end