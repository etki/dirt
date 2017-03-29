require_relative '../model/configuration/configuration'

module Semble
  module Configuration
    class OverlayConfiguration < ::Semble::Model::Configuration::Configuration

      # @param [Interface[]] configurations
      def initialize(*configurations)
        @configurations = configurations
      end

      self.property_list.each do |property|
        define_method property do
          @configurations.reduce(nil) do |carrier, candidate|
            carrier.nil? ? candidate.send(property) : carrier
          end
        end
      end
    end
  end
end
