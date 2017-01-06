require 'fileutils'
require 'file_system/driver/interface'

module Semble
  module FileSystem
    module Driver
      class Disk < Interface
        def working_directory
          Pathname.getwd
        end

        def working_directory=(path)
          Dir.chdir(path.to_s)
        end

        def read(path)
          IO.read(path.to_s)
        end

        def write(path, content)
          IO.write(path.to_s, content)
        end

        def glob(pattern, *flags)
          Dir.glob(pattern.to_s, *flags)
        end

        def copy(source, target)
          FileUtils.copy_entry(source, target)
        end

        def mkdir(path)
          FileUtils.makedirs(path.to_s)
        end

        def exists?(path)
          File.exist?(path)
        end

        def directory?(path)
          File.directory?(path)
        end

        def file?(path)
          File.file?(path)
        end
      end
    end
  end
end