require 'fileutils'
require 'logging/logger_factory'

module Semble
  module Engine
    class ImageWriter
      def initialize(configuration, render_engine)
        @configuration = configuration
        @render_engine = render_engine
        @logger = Semble::Logging::LoggerFactory.get
      end

      # @param image [Semble::Model::VersionImage]
      def write(image)
        target = compute_image_directory(image)
        image.sources.each do |entry|
          source = entry.origin.path
          destination = target.join(entry.path)
          if entry.type == :template
            render_file(source, destination, image.context)
          else
            copy_file(source, destination)
          end
        end
      end

      def mirror(origin, target)
        source = compute_image_directory(origin)
        destination = compute_image_directory(target)
        @logger.debug("Mirroring image `#{origin.platform}:#{origin.version}` as " +
                          "`#{target.platform}:#{target.version}`")
        FileUtils.copy(source, destination)
      end

      private
      def copy_file(source, destination)
        FileUtils.makedirs(destination.dirname.to_s)
        @logger.debug("Copying `#{source}` to #{destination}")
        FileUtils.copy(source, destination)
      end

      def render_file(source, destination, context)
        FileUtils.makedirs(destination.dirname.to_s)
        template = IO.read(source)
        content = @render_engine.render(template, context)
        IO.write(destination.to_s, content)
      end

      def prepare_for(destination)
        parent_dir = destination.dirname.to_s
        unless File.exist?(parent_dir)
          @logger.debug("Creating directory `#{parent_dir}`")
          FileUtils.makedirs(parent_dir)
        end
      end

      def compute_image_directory(image)
        @configuration.structure.output.join(image.platform.to_s, image.version.to_s)
      end
    end
  end
end