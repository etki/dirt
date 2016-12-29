require 'configuration/reader'
require 'configuration/validator'

module Semble
  module CLI
    class CLI
      def build(configuration_path, *versions)
        api = get_api(configuration_path)
        if versions.empty?
          result = api.build_all
        else
          result = versions.map do |input|
            Semble::ImageRequest.from_string(input)
          end .map do |request|
            api.build(request)
          end
        end
        # todo process result
      end

      private
      def get_api(configuration_path)
        Semble::Engine::Api.new(read_configuration(configuration_path))
      end

      def read_configuration(path)
        configuration = Semble::Configuration::Reader.new.read(path)
        validation_result = Semble::Configuration::Validator.new.validate(configuration)
        unless validation_result[:valid]
          chunks = ['Configuration at is invalid:']
          validation_result[:violations].each do |property, violations|
            violations.each do |violation|
              chunks.push("#{property}: #{violation}")
            end
          end
          message = chunks.join("\n -")
          raise ArgumentError, message
        end
        configuration
      end
    end
  end
end