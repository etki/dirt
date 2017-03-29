module Semble
  module Configuration
    module File
      class Locator
        def initialize(filesystem)
          @filesystem = filesystem
        end

        # @param [Pathname] working_directory
        # @return [Array<Pathname>] List of paths to semble.yml in parent directories.
        def locate(working_directory)
          cursor = working_directory
          result = []
          loop do
            path = cursor.join('semble.yml')
            result.push(path) if @filesystem.exists?(path)
            previous = cursor
            cursor = cursor.parent
            break if cursor.nil? or cursor == previous
          end
          result
        end
      end
    end
  end
end