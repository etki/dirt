module Semble
  module Model
    module Configuration
      class Configuration
        # @return [Array<Pathname>]
        def source_directories
          prevent
        end

        # @return [Pathname]
        def output_directory
          prevent
        end

        # @return [Array<String>]
        def whiteout_prefixes
          prevent
        end

        # @return [Array<String>]
        def template_extensions
          prevent
        end

        # @return [Hash{String, Array<Semble::Model::Configuration::Target>}]
        def schema
          prevent
        end

        # @return [Symbol]
        def short_version_strategy
          prevent
        end

        # @return [Array<String>]
        def default_platforms
          prevent
        end

        # @return [Pathname]
        def working_directory
          prevent
        end

        # @return [String|Integer]
        def log_threshold
          prevent
        end

        # @return [IO]
        def log_target
          prevent
        end

        def self.property_list
          %w(
            source_directories
            output_directory
            whiteout_prefixes
            template_extensions
            schema
            short_version_strategy
            default_platforms
            working_directory
            log_threshold
            log_target
          ).map(&:to_sym)
        end

        def property_list
          Configuration.property_list
        end

        private
        def prevent
          raise 'Abstract method not implemented'
        end
      end
    end
  end
end
