module Semble
  module Model
    module Blueprints
      class FileSource
        # @!attribute [rw] set
        #   @return [Semble::Model::Blueprints::SourceSet] Set this source belongs to
        attr_accessor :set
        # @!attribute [rw] path
        #   @return [Pathname] Relative path to resulting file inside image fileset
        attr_accessor :path
        # @!attribute [rw] source
        #   @return [Pathname] Absolute path to source file
        attr_accessor :source
        # @!attribute [rw] type
        #   @return [:template, :unknown]
        attr_accessor :type

        def to_s
          "File source #{path}, type: #{type}"
        end
      end
    end
  end
end