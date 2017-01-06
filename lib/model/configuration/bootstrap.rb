module Semble
  module Model
    module Configuration
      class Bootstrap
        # @!attribute [rw] configuration_file
        #   @return [Pathname]
        attr_accessor :configuration_file
        # @!attribute [rw] log_threshold
        #   @return [Integer, :debug, :info, :warn, :error]
        attr_accessor :log_threshold
        # @!attribute [rw] log_target
        #   @return [IO]
        attr_accessor :log_target
        # @!attribute [rw] working_directory
        #   @return [Pathname]
        attr_accessor :working_directory
      end
    end
  end
end