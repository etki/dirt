module Semble
  module Model
    module Configuration
      class Target
        # @type [String]
        attr_accessor :platform
        # @type [Semble::Model::Version]
        attr_accessor :version
        # @type [Hash]
        attr_accessor :context
      end
    end
  end
end