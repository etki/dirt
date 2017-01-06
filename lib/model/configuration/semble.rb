module Semble
  module Model
    module Configuration
      class Semble
        # @!attribute [rw] working_directory
        #   @return [Pathname]
        attr_accessor :working_directory
        # @!attribute [rw] sources
        #   @return [Pathname]
        attr_accessor :sources
        # @!attribute [rw] output
        #   @return [Pathname]
        attr_accessor :output
        # @!attribute [rw] targets
        #   @return [Hash<Symbol, Hash<Semble::Model::Version, Semble::Model::Blueprints::Target>]
        attr_accessor :targets
        # @!attribute [rw] short_version_strategy
        #   @return [:none, :earliest, :latest]
        attr_accessor :short_version_strategy
        # @!attribute [rw] log_target
        #   @return [IO]
        attr_accessor :log_target
        # @!attribute [rw] log_threshold
        #   @return [Integer, :debug, :info, :warn, :error]
        attr_accessor :log_threshold
      end
    end
  end
end