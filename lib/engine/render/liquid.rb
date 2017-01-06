require 'liquid'

module Semble
  module Engine
    module Rendering
      # Just a simple wrapper for Liquid rendering engine
      class Liquid
        # @param [String] template
        # @param [Hash] context
        # @return [String]
        def render(template, context)
          parsed = ::Liquid::Template.parse(template, {error_mode: :strict})
          parsed.render!(context, {strict_variables: true})
        end
      end
    end
  end
end