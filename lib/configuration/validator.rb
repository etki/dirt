require 'configuration/configuration'

module Semble
  module Configuration
    class Validator
      def validate(configuration)
        valid = true
        violations = {}

        sources = configuration.structure.sources
        unless sources.exist?
          violations['$.structure.sources'] = ["Sources directory #{sources} does not exist"]
          valid = false
        end

        variants = [SHORT_VERSION_STRATEGY_LATEST, SHORT_VERSION_STRATEGY_NONE]
        short_version_strategy = configuration.short_version_strategy
        unless variants.include?(short_version_strategy)
          violations['$.short_version_strategy'] = ["Unknown short version strategy #{short_version_strategy}"]
          valid = false
        end

        {
            valid: valid,
            violations: violations
        }
      end
    end
  end
end