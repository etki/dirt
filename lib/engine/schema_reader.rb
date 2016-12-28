require 'yaml'
require '../model/file_source'
require '../model/version_specification'
require '../model/version'
require '../logging/logger_factory'

module Semble
  module Engine
    # Reads project schema. Schema can be described as following:
    # schema: hash
    #   platform-name: hash
    #      version: Semble::Model::VersionSpecification
    class SchemaReader
      TEMPLATE_EXTENSIONS = %w(.liquid .twig)
      CONFIGURATION_DIRECTORY = '.semble'
      CONTEXT_FILE_NAME = 'context.yml'
      WHITEOUT_PREFIX = '.wh.'

      def initialize
        @logger = LoggerFactory.get
      end

      def read(location)
        @logger.info("Reading project schema from #{location}")
        output = {}
        location.each_child do |path|
          path = location.join(path)
          return unless path.directory?
          platform = location.basename.to_sym
          output[platform] = read_platform(platform, path)
        end
        output
      end

      private
      def read_platform(platform, location)
        @logger.debug("Reading platform `#{platform}` schema from #{location}")
        output = {}
        location.each_child do |path|
          return unless path.directory?
          begin
            version = Semble::Model::Version.new(path.to_s)
          rescue Exception => e
            logger.error("Failed to parse version out of directory `#{path}` (while reading platform `#{platform}`) " +
                             "with error #{e}, skipping")
            return
          end
          spec = read_version(platform, version, location.join(path))
          key = version.normalize
          if output.has_key?(key)
            @logger.warn("Double declaration of version `#{key}` for platform `#{platform}`, merging")
            output[key].merge(spec)
          else
            output[key] = spec
          end
          output
        end
      end

      def read_version(platform, version, location)
        @logger.debug("Reading project version `#{version}` for platform `#{platform}` from #{location}")
        Semble::Model::VersionSpecification.new do |spec|
          spec.platform = platform
          spec.version = version

          files = scan_version_directory(location)
          whiteouts = files.select do |path|
            is_whiteout_file(path)
          end .map do |path|
            read_whiteout_file(path, location)
          end
          spec.whiteouts.merge(whiteouts)

          entries = files.reject do |path|
            is_whiteout_file(path)
          end .map do |path|
            read_file_entry(path, location, platform, version)
          end
          spec.entries.merge(entries)

          context_file = location.join(CONFIGURATION_DIRECTORY, CONTEXT_FILE_NAME)
          if context_file.exist?
            begin
              YAML.load(context_file.read)
            rescue Exception => e
              @logger.error("Error whiel reading context for version #{version} for platform #{platform}: #{e}")
            end
          end
        end
      end

      def scan_version_directory(location)
        Dir.glob(File.join(location.to_s, '**/*'), File::FNM_DOTMATCH).map do |path|
          Pathname.new(path)
        end.select do |path|
          return false if path.directory?
          relative = path.relative_path_from(location)
          first_component = relative.each_filename.first
          first_component != CONFIGURATION_DIRECTORY
        end
      end

      def read_file_entry(location, root, platform, version)
        Semble::Model::FileSource.new do |entry|
          entry.origin = Semble::Model::FileSource::Origin.new do |origin|
            origin.platform = platform
            origin.version = version
            origin.path = location
          end
          entry.path = location.relative_path_from(root)

          if TEMPLATE_EXTENSIONS.include?(location.extname)
            entry.type = :template
            entry.path = entry.path.dirname.join(entry.path.basename(location.extname))
          end
        end
      end

      def read_whiteout_file(path, root)
        path.dirname.join(path.basename.to_s.sub(WHITEOUT_PREFIX, '')).relative_path_from(root)
      end

      def is_whiteout_file(path)
        path.basename.to_s.start_with?(WHITEOUT_PREFIX)
      end
    end
  end
end