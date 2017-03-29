require_relative '../../model/configuration/file_structure'
require_relative '../constants'
require 'dry-validation'

module Semble
  module Configuration
    module File
      class Validator
        include Semble::Configuration::Constants
        def validate(raw_config)
          schema = Dry::Validation.Schema do
            required(:targets).schema do
              each do
                schema do
                  each do
                    required(:context).maybe(:hash?)
                  end
                end
              end
            end
            required(:structure).schema do
              required(:sources).maybe(type?(String) | type?(Array))
              required(:output).maybe(:string?)
            end
            required(:logging).schema do
              required(:threshold).maybe(:string?)
              required(:target).maybe(:string?)
            end
            required(:short_version_strategy).value(eql?(SHORT_VERSION_STRATEGY_NONE) | eql?(SHORT_VERSION_STRATEGY_LATEST))
          end
          schema.(raw_config)
        end
      end
    end
  end
end
