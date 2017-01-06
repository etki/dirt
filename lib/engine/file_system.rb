require 'pathname'

module Semble
  module Engine
    class FileSystem
      attr_accessor :cwd

      # @param [Semble::FileSystem::Driver::Inteface] driver
      def initialize(driver)
        @driver = driver
      end

      def write(path, content)
        @driver.write(@driver.working_directory.join(path), content)
      end

      def read(path)
        @driver.read(@driver.working_directory.join(path))
      end

      def copy(source, target)
        @driver.copy(@driver.working_directory.join(source), @driver.working_directory.join(target))
      end

      def scan(pattern)
        @driver.glob(@driver.working_directory.join(pattern), File::FNM_DOTMATCH).map { |entry| Pathname.new(entry) }
      end
      
      def directory?(path)
        @driver.directory?(path)
      end
      
      def file?(path)
        @driver.file?(path)
      end
    end
  end
end