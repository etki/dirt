require 'yaml'
require 'logging/logger_factory'
require 'engine/container'
require 'engine/constants'
require 'model/configuration/semble'
require 'model/blueprints/target'
require 'model/version'
require 'model/id'

module Semble
  module Bootstrap
    class ConfigurationReader
      def initialize(filesystem, logger_factory)
        @filesystem = filesystem
        @logger = logger_factory.get(self.class)
      end

      # @param [Pathname] path
      # @param [Semble::Model::Configuration::Bootstrap] bootstrap_config
      def read_configuration(path, bootstrap_config)
        working_directory = bootstrap_config.working_directory
        @logger.debug("Reading configuration at `#{path}` using working directory `#{working_directory}`")
        content = @filesystem.read(path)
        parsed = YAML.load(content)
        configuration = Semble::Model::Configuration::Semble.new

        configuration.working_directory = working_directory
        directories = {
            sources: Semble::Engine::Constants::DEFAULT_SOURCES_DIRECTORY,
            output: Semble::Engine::Constants::DEFAULT_OUTPUT_DIRECTORY
        }
        directories.each do |name, default_location|
          configuration.send(name.to_s + '=', read_configuration_directory(parsed, working_directory, name, default_location))
        end
        configuration.short_version_strategy = read_short_version_strategy(parsed)
        configuration.targets = read_targets(parsed)
        # Currently there's no time to play with files. Next release, maybe.
        configuration.log_target = STDOUT
        configuration.log_threshold = read_log_threshold(parsed, bootstrap_config.log_threshold)
        configuration
      end

      private

      def read_log_threshold(parsed, bootstrap_value)
        @logger.debug('Reading log threshold')
        if bootstrap_value
          @logger.debug("Using bootstrap value #{bootstrap_value}")
          threshold = bootstrap_value
        elsif parsed['log_threshold']
          threshold = parsed['log_threshold'].to_s.downcase.to_sym
          unless Semble::Engine::Constants::LOGGER_THRESHOLDS.include?(threshold)
            raise "Unknown logger threshold #{threshold}"
          end
          @logger.debug("Read logger threshold #{threshold} from configuration")
        else
          threshold = Semble::Engine::Constants::DEFAULT_LOGGER_THRESHOLD
          @logger.debug('No value has been specified for logger threshold, using default one')
        end
        @logger.debug("Computed logger threshold: #{threshold}")
        threshold
      end

      def read_configuration_directory(parsed, working_directory, directory_name, default_value)
        @logger.debug("Reading #{directory_name} directory location from configuration")
        if parsed[directory_name]
          path = parsed[directory_name]
          @logger.debug("Found #{directory_name} directory location in config: `#{path}`")
        else
          path = default_value
          @logger.debug("Using default value for #{directory_name} directory location: `#{path}`")
        end
        working_directory.join(path).tap do |absolute_path|
          @logger.debug("Computed absolute path for #{directory_name} directory: `#{absolute_path}`")
        end
      end

      def read_short_version_strategy(parsed)
        @logger.debug('Reading short version strategy from configuration')
        unless parsed.has_key?('short_version_strategy')
          @logger.debug('Short version strategy unspecified, returning default value')
          return Semble::Engine::Constants::DEFAULT_SHORT_VERSION_STRATEGY
        end
        value = parsed['short_version_strategy'].to_s.to_sym
        if Semble::Engine::Constants::SHORT_VERSION_STRATEGIES.include?(value)
          @logger.debug("Read short version strategy value `#{value}`")
          return value
        end
        raise "Unknown short version strategy specified: #{value}"
      end

      def read_targets(parsed)
        @logger.debug('Reading targets from configuration')
        source = (parsed['targets'] or {})
        pairs = source.map do |platform, configuration|
          platform = platform.to_sym
          [platform, read_platform_targets(platform, configuration)]
        end
        Hash[pairs]
      end

      def read_platform_targets(platform, hash)
        @logger.debug("Reading targets for platform #{platform}")
        pairs = hash.map do |key, configuration|
          version = Semble::Model::Version.new(key.to_s)
          id = Semble::Model::Id.new(platform, version)
          [version, read_target_configuration(id, configuration)]
        end
        Hash[pairs]
      end

      def read_target_configuration(id, hash)
        hash = (hash or {})
        Semble::Model::Blueprints::Target.new.tap do |target|
          target.id = id
          target.context = (hash['context'] or {})
          @logger.debug("Read target #{target}")
        end
      end

      def read_default_platforms(parsed)
        default_platforms = parsed['default_platforms']
        if default_platforms.kind_of?(String)
          @logger.warn('Default platforms configuration value provided as string, converting to array')
          default_platforms = [default_platforms]
        end
        if default_platforms
          unless default_platforms.kind_of?(Array)
            raise "Invalid default platforms value `#{default_platforms}`: string array expected"
          end
          default_platforms.map! {|entry| entry.to_s.to_sym}
          @logger.debug("Using provided value for default platforms: #{default_platforms}")
        else
          default_platforms = Semble::Engine::Constants::DEFAULT_PLATFORMS
          @logger.debug("Using default value for default platforms: #{default_platforms}")
        end
        default_platforms
      end
    end
  end
end