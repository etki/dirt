require 'pathname'
require 'source/layer'
require 'source/entry'

module Semble
  module Source
    class LayerReader

      WHITEOUT_PREFIX = '.wh.'
      # todo this should be passed with config
      TEMPLATE_EXTENSIONS = ['.twig', '.liquid']

      def read(directory, platform, version)
        root = Pathname.new(File.absolute_path(directory))
        contents = scan_directory(root).map { |path| Pathname.new(path) }
        entries = fetch_entries(contents, platform, version, root)
        whiteouts = fetch_whiteouts(contents, root)

        Semble::Source::Layer.new do |layer|
          layer.platform = platform
          layer.set_version(version)
          layer.sources.add(root)
          layer.entries.merge!(entries)
          layer.whiteouts.merge(whiteouts)
        end
      end

      private
      def scan_directory(path)
        Dir.glob(File.join(path.to_s, '**/*'), File::FNM_DOTMATCH).select do |node|
          filename = File.basename(node)
          filename != '.' and filename != '..' and not File.directory?(node)
        end.map do |node|
          Pathname.new(node)
        end
      end

      # @param paths [Array<Pathname>]
      def fetch_whiteouts(paths, root)
        paths.select do |path|
          path.basename.to_s.start_with?(WHITEOUT_PREFIX)
        end .map do |path|
          file_name = path.basename.sub(WHITEOUT_PREFIX, '')
          path.dirname.join(file_name).relative_path_from(root)
        end
      end

      private
      def fetch_entries(paths, platform, version, root)
        entries = paths.select do |path|
          not path.basename.to_s.start_with?('.wh.')
        end .map do |path|
          entry = Semble::Source::Entry.new
          entry.platform = platform
          entry.version = version
          entry.source = path
          extension = TEMPLATE_EXTENSIONS.find { |extension| path.to_s.end_with?(extension) }
          implicit_path = path
          if extension
            implicit_path = Pathname.new(implicit_path.to_s.chomp(extension))
            entry.type = :template
          else
            entry.type = :unknown
          end
          entry.path = implicit_path.relative_path_from(root)
          [entry.path, entry]
        end
        Hash[entries]
      end
    end
  end
end