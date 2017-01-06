require 'logging/logger_factory'
require 'engine/container'
require 'bootstrap/configuration_reader'
require 'bootstrap/source_set_reader'
require 'file_system/driver/disk'
require 'model/blueprints/schema'

module Semble
  module Bootstrap
    class ContainerBuilder
      # @param [Semble::Model::Configuration::Bootstrap] config
      # @param [Semble::Engine::Container] container
      def bootstrap(config, container = nil)
        logger_factory = Semble::Logging::LoggerFactory.new(config.log_target, config.log_threshold)
        container = Semble::Engine::Container.new unless container

        container.filesystem_driver = Semble::FileSystem::Driver::Disk.new unless container.filesystem_driver
        container.filesystem_driver.working_directory = config.working_directory if config.working_directory

        configuration_reader = Semble::Bootstrap::ConfigurationReader.new(container.filesystem, logger_factory)
        container.configuration = configuration_reader.read_configuration(config.configuration_file, config)

        source_reader = Semble::Bootstrap::SourceSetReader.new(container.filesystem, logger_factory)
        source_sets = source_reader.read(container.configuration.sources)

        container.schema = Semble::Model::Blueprints::Schema.new.tap do |schema|
          schema.add_targets(*container.configuration.targets.values.flat_map(&:values))
          schema.add_source_sets(*source_sets.values.flat_map(&:values))
        end
        container
      end
    end
  end
end