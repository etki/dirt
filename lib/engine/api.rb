require 'engine/image_builder'
require 'engine/image_writer'
require 'engine/render_engine'
require 'model/build_report'
require 'fileutils'

module Semble
  module Engine
    class Api
      DEFAULT_PLATFORM = :_default

      def initialize(configuration)
        @configuration = configuration
        @builder = ImageBuilder.new
        @writer = ImageWriter.new(@configuration, RenderEngine.new)
        @logger = Semble::Logging::LoggerFactory.get
      end

      def build(request)
        @logger.info("Building project for platform `#{request}` / version `#{request.version}`")
        report = BuildReport.new(request.platform, request.version, :compute)
        begin
          target = get_target(request)
          target_context = target&.context ? target.context : {}
          chunks = schema.get_slice(DEFAULT_PLATFORM, version)
          unless platform == DEFAULT_PLATFORM
            chunks = chunks.concat(schema.get_slice(request.platform, request.version))
          end
          image = @builder.build(chunks, platform, version, target_context)
          @writer.write(image)
          report.complete
        rescue Exception => e
          report.abort(e)
        end
      end

      def build_all
        #todo
      end

      def schema
        @schema = SchemaReader.new.read(@configuration.structure.sources) unless @schema
        @schema
      end

      private
      def get_target(request)
        platform = (@configuration.targets[request.platform] or {})
        platform[request.version.normalize]
      end
    end
  end
end