module Semble
  module Source
    class Layer
      # @return Hash{Pathname => Semble::Source::Entry}
      attr_reader :entries
      # @return Set<Pathname>
      attr_reader :whiteouts
      # @return Set<Pathname>
      attr_reader :sources
      # forcing to use #set_version
      attr_reader :version
      attr_reader :raw_versions
      attr_accessor :platform


      def initialize(&block)
        @raw_versions = Set.new
        @entries = Hash.new
        @whiteouts = Set.new
        @sources = Set.new
        if block
          block.call(self)
        end
      end

      def set_version(version)
        raw_versions.add(version)
        unless @version
          @version = version.normalize
        end
      end

      def merge(other)
        result = clone
        other.entries.each do |path, entry|
          result.entries[path] = entry
        end
        other.whiteouts.each do |whiteout|
          whiteouts.add(whiteout)
        end
        other.sources.each do |source|
          sources.add(source)
        end
        other.raw_versions do |version|
          push_version(version)
        end
      end
    end
  end
end