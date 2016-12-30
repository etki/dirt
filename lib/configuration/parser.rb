require 'yaml'
require 'logging/logger_factory'
require 'configuration/configuration'

module Semble
  module Configuration
    class Parser

      def initialize
        @logger = Semble::Logging::LoggerFactory.get
      end

      def parse(raw, base_path)
        raw = YAML.load(raw)
        container = Configuration.new
        container.schema = parse_schema_configuration((raw['schema'] or {}))
        container.structure = parse_structure_configuration((raw['structure'] or {}), base_path)
        container.default_platform = raw['default_platform']
        key = 'short_version_strategy'
        container.short_version_strategy = raw[key] ? raw[key].to_sym : SHORT_VERSION_STRATEGY_NONE
        container
      end

      def parse_schema_configuration(hash)
        tuples = hash.each do |platform, platform_spec|
          versions = (platform_spec['versions'] or {}).map do |version, version_spec|
            version = Semble::Model::Version(version)
            [Semble::Model::Version(version), parse_version_configuration(version, version_spec)]
          end
          versions = Hash[versions]
          [platform, versions]
        end
        Hash[tuples]
      end

      def parse_version_configuration(version, hash)
        VersionConfiguration.new(Semble::Model::Version.new(version), (hash['context'] or {}))
      end

      def parse_structure_configuration(raw, base_path)
        StructureConfiguration.new do |c|
          c.sources = base_path.join((raw['sources'] or DEFAULT_SOURCES_PATH))
          c.output = base_path.join((raw['output'] or DEFAULT_OUTPUT_PATH))
        end
      end
    end
  end
end