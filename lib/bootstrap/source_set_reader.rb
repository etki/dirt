require 'yaml'
require 'engine/container'
require 'model/blueprints/source_set'
require 'model/blueprints/file_source'
require 'model/version'
require 'model/id'

module Semble
  module Bootstrap
    # Given arbitrary location, this class scans it for source sets, expecting
    # following structure:
    #
    # ```
    # /%given location%
    #   /%platform-name%:
    #     /%version%:
    #       /.semble
    #         /context.yml
    #       /source-file-a.yml
    #       /tree
    # ```
    #
    # This reader will consume such structure, outputting two-dimensional hash:
    #
    # ```
    # {
    #   <platform / Symbol>: {
    #     <version / Semble::Model::Version>: <source set / Semble::Model::Blueprints::SourceSet>
    #   }
    # }
    # ```
    #
    class SourceSetReader
      # @param [Semble::Engine:FileSystem] filesystem
      # @param [Semble::Logging::LoggerFactory] logger_factory
      def initialize(filesystem, logger_factory)
        @filesystem = filesystem
        @logger = logger_factory.get(self.class)
      end

      # @param [Pathname] directory
      # @return [Hash<Symbol, Hash<Semble::Model::Version, Semble::Model::Blueprints::SourceSet>>]
      def read(directory)
        @logger.debug("Reading source sets from `#{directory}`")
        pairs = @filesystem.scan(directory + '*').select do |path|
          @filesystem.directory?(path) and not %w{. ..}.include?(path.basename.to_s)
        end .map do |path|
          platform = path.basename.to_s.to_sym
          [platform, read_platform(platform, path)]
        end
        Hash[pairs]
      end

      private
      def read_platform(platform, directory)
        @logger.debug("Reading source sets for platform `#{platform}`")
        pairs = @filesystem.scan(directory + '*').select do |path|
          @filesystem.directory?(path) and not %w{. ..}.include?(path.basename.to_s)
        end .map do |path|
          version = Semble::Model::Version.new(path.basename.to_s)
          id = Semble::Model::Id.new(platform, version)
          [version, read_platform_set(id, path)]
        end
        Hash[pairs]
      end

      def read_platform_set(id, directory)
        Semble::Model::Blueprints::SourceSet.new(id, directory).tap do |set|
          @logger.debug("Reading source set `#{id}` in directory #{directory}")
          set.directory = directory
          config_directory = directory.join(Semble::Engine::Constants::SOURCE_SET_CONFIG_DIRECTORY)
          context_file = config_directory.join(Semble::Engine::Constants::SOURCE_SET_CONTEXT_FILE_NAME)
          if @filesystem.file?(context_file)
            @logger.debug("Found context file for source set `#{id}` at `#{context_file}`")
            set.context = YAML.load(@filesystem.read(context_file))
          end
          @filesystem.scan(directory + '**/*').each do |path|
            next if path.directory?
            relative_path = path.relative_path_from(directory)
            next if relative_path.each_filename.first == Semble::Engine::Constants::SOURCE_SET_CONFIG_DIRECTORY
            if relative_path.basename.to_s.start_with?(Semble::Engine::Constants::WHITEOUT_PREFIX)
              filename = relative_path.basename.to_s.sub(Semble::Engine::Constants::WHITEOUT_PREFIX, '')
              whiteout = relative_path.dirname.join(filename)
              set.whiteouts << whiteout
            else
              entry = Semble::Model::Blueprints::FileSource.new
              entry.path = relative_path
              entry.source = path
              entry.type = :unknown
              entry.set = set
              if Semble::Engine::Constants::TEMPLATE_EXTENSIONS.include?(path.extname)
                entry.type = :template
                entry.path = relative_path.dirname.join(relative_path.basename(relative_path.extname))
              end
              set.entries[entry.path] = entry
            end
          end
        end
      end
    end
  end
end