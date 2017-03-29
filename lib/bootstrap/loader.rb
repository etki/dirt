require_relative '../logging/logger_factory'
require_relative '../configuration/default_configuration'
require_relative '../configuration/overlay_configuration'
require_relative '../configuration/file/file_locator'

module Semble
  module Bootstrap
    class Loader

      # @param [Semble::FileSystem::Driver::Configuration] filesystem
      def initialize(filesystem)
        @filesystem = filesystem
      end

      # @param [Semble::Configuration::Interface] configuration
      # @return [Semble::Engine::Container]
      def load(configuration)
        fallback = Semble::Configuration::DefaultConfiguration.new
        configuration = Semble::Configuration::OverlayConfiguration.new(configuration, fallback)
        logger_factory = Semble::Logging::LoggerFactory.new(configuration.log_target, configuration.log_threshold)
        logger = logger_factory.get(self.class)
        logger.debug('Building Semble')
        logger.debug('Locating semble.yml files')
        file_locator = Semble::Configuration::Locator.new(@filesystem)
        candidates = file_locator.locate(configuration.working_directory)
        if candidates.empty?
          logger.warn('Failed to find any semble.yml, proceeding using runtime configuration')
        else
          file_reader = Semble::Configuration::FileReader.new(@filesystem)
          file_configurations = candidates.map do |candidate|
            begin
              file_reader.read(candidate)
            rescue Exception => e
              logger.warn("Failed to read configuration file #{candidate} due to error: #{e}")
              nil
            end
          end .select
          configuration = Semble::Configuration::OverlayConfiguration.new(configuration, *file_configurations)
        end
        Semble::Engine::Builder.new.build(configuration, @filesystem)
      end
    end
  end
end