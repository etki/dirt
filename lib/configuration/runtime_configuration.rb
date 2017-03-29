require_relative '../model/configuration/configuration'

module Semble
  module Configuration
    class RuntimeConfiguration < ::Semble::Model::Configuration::Configuration
      property_list.each do |property|
        attr_accessor property
      end
    end
  end
end