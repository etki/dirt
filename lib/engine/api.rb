require 'logging/logger_factory'
require 'model/api/aggregate_build_report'

module Semble
  module Engine
    class API
      # @param [Semble::Engine::Container] container
      def initialize(container)
        @container = container
        @logger = Semble::Logging::LoggerFactory.get
      end

      def build(*build_requests)
        return Semble::Model::API::AggregateBuildReport.new
        build_requests.map do |request|
          @logger.info("Processing build request `#{request.platform}:#{request.version}`")
        end
      end

      def build_all
        return Semble::Model::API::AggregateBuildReport.new
        @logger.info('Building all known versions')
        schema = @container.schema
        schema.each do |platform, version_set|
          version_set.each do |version_spec|
            build(BuildRequest.new(version_spec.image_id))
          end
        end
        if @container.configuration.short_version_strategy == :latest
          @logger.info('Processing resulting set to add shortened versions')
          index = {}
          schema.each do |platform, version_set|
            index[platform] = {}
            version_set.each do |version_spec|
              version = version_spec.image_id.version
              index[platform][version] = {
                  exists: true,
                  source: version_spec.image_id
              }
              candidate = version.shorten
              until candidate.nil?
                already_exists = false
                occupied_by_later_version = false
                if index[platform].has_key?(candidate)
                  rival = index[platform][candidate]
                  already_exists = rival[:exists]
                  occupied_by_later_version = rival[:source_version] > version
                end
                if not already_exists and not occupied_by_later_version
                  index[platform][candidate] = {
                      exists: false,
                      source: version_spec.image_id
                  }
                end
                candidate.shorten!
              end
            end
          end
          index.each do |platform, versions|
            versions.each do |version, spec|
              next if spec[:exists]
              mirror(MirrorRequest.new(spec[:source], ImageId.new(platform, version)))
            end
          end
        end
      end

      def mirror(*mirror_requests)
        mirror_requests.map do |request|
          @logger.info("Mirroring platform `#{request.source}` to `#{request.target}`")
        end
      end

      private
      def execute_plan(plan)
        @logger.debug("Executing build plan #{plan}")
        @container.build_plan_executor.execute(plan)
      end
    end
  end
end