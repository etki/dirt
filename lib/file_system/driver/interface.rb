module Semble
  module FileSystem
    module Driver
      class Interface
        def working_directory
          raiser
        end

        def working_directory=(path)
          raiser
        end

        def read(path)
          raiser
        end

        def write(path, content)
          raiser
        end

        def glob(pattern, *flags)
          raiser
        end

        def copy(source, target)
          raiser
        end

        def mkdir(path)
          raiser
        end

        def exists?(path)
          raiser
        end

        def directory?(path)
          raiser
        end

        def file?(path)
          raiser
        end

        private
        def raiser
          raise 'Method not implemented'
        end
      end
    end
  end
end
