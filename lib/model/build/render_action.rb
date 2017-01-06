module Semble
  module Model
    module Build
      class RenderAction
        attr_accessor :source_directory
        attr_accessor :source_relative_path
        attr_accessor :target_directory
        attr_accessor :target_relative_path
        attr_accessor :context

        def source_absolute_path
          source_directory + source_relative_path
        end

        def target_absolute_path
          target_directory + target_relative_path
        end
      end
    end
  end
end