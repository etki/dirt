require 'pathname'

module Semble
  module Test
    class DiffableDirectory

      attr_reader :contents
      attr_reader :path

      def initialize(path)
        @path = Pathname.new(path)
      end

      def get_contents
        return @contents if @contents
        @contents = Dir.glob(@path.to_s + '/**/*', File::FNM_DOTMATCH).map do |path|
          Pathname.new(path).relative_path_from(@path)
        end .select do |path|
          not path.directory?
        end .sort
      end

      def read(path)
        location = @path.join(path)
        return nil unless File.exist?(location)
        IO.read(location)
      end

      def diff(other)
        diff = {}

        self_extras = get_contents - other.get_contents
        other_extras = other.get_contents - get_contents
        overlap = get_contents - self_extras

        self_extras.each do |path|
          diff[path] = "Is not present in directory #{@path}"
        end

        other_extras.each do |path|
          diff[path] = "Is not present in directory #{other.path}"
        end

        overlap.each do |path|
          if read(path) != other.read(path)
            diff[path] = 'Contents differ'
          end
        end

        diff
      end
    end
  end
end