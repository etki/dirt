require_relative '../../model/configuration/file_structure'

module Semble
  module Configuration
    module File
      class Parser
        def parse(data)
          representation = Semble::Model::Configuration::FileStructure.new
          representation.validate
        end
      end
    end
  end
end
