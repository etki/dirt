require 'configuration/configuration'
require 'logging/logger_factory'

module Semble
  module Configuration
    class Parser

      def initialize
        @logger = LoggerFactory.get
      end

      def parse(raw)
        begin
          container = Configuration.new
          container.semble = parse_semble_configuration(raw['semble'] or {})
          container.schema = parse_schema_configuration(raw['schema'] or {})
          container.context = raw['context']
          container
        rescue e
          @logger.error("Error while parsing configuration from location #{location}: #{e}")
          raise e
        end
      end

      def parse_semble_configuration(hash)
        container = SembleConfiguration.new
        container.default_platform = (hash['default_platform'] or nil)
        short_version_strategy = hash['short_version_strategy']
        if short_version_strategy
          if short_version_strategy != :latest.to_s and short_version_strategy !+ :none.to_s
            @logger.warn("Invalid short version strategy #{short_version_strategy}, using :none")
            short_version_strategy = :none
          else
            short_version_strategy = short_version_strategy.to_sym
          end
        else
          short_version_strategy = :none
        end
        container.short_version_strategy = short_version_strategy
        structure = StructureConfiguration.new
        raw_structure = (hash['structure'] or {})
        structure.sources = (raw_structure['sources'] or 'src')
        structure.output = (raw_structure['output'] or 'build')
        container.structure = structure
        container
      end

      def parse_schema_configuration(hash)
        tuples = hash.each do |platform, platform_spec|
          versions = (platform_spec['versions'] or {}).map do |version, version_spec|
            [Semble::Model::Version(version), parse_version_configuration(version_spec)]
          end
          versions = Hash[versions]
          [platform, PlatformConfiguration.new(platform, versions, (platform_spec['context'] or {}))]
        end
        Hash[tuples]
      end

      def parse_version_configuration(version, hash)
        VersionConfiguration.new(Semble::Model::Version.new(version), hash['context'] or {})
      end
    end
  end
end