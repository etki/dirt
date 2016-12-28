module Semble
  module Model
    class Schema
      def initialize(structure = {})
        @structure = structure
      end

      def add_version(version_spec)
        platform = version_spec.platform
        version = version_spec.version.normalize
        @structure[platform] = {} unless @structure[platform]
        if @structure[platform].has_key?(version)
          @structure[platform][version] = @structure[platform][version].merge(version_spec)
        else
          @structure[platform][version] = version_spec
        end
      end

      def get_slice(platform, version)
        platform_versions = (@structure[platform] or {})
        platform_versions.keys.select do |version_key|
          version_key <= version
        end .map do |version_key|
          platform_versions[version_key]
        end .sort
      end
    end
  end
end