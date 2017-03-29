require 'yaml'

module Semble
  module Configuration
    module File
      class Reader
        # @param [Semble::FileSystem::Driver::Interface] filesystem
        def initialize(filesystem)
          @filesystem = filesystem
          @parser = Parser.new
        end
        def read(path)
          @parser.parse(YAML.parse(@filesystem.read(path)))
        end
      end
    end
  end
end
