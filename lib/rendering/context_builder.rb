module Semble
  module Rendering
    class ContextBuilder
      def merge(value_a, value_b)
        if value_a.is_a?(Hash) and value_b.is_a?(Hash)
          target = value_a.clone
          value_b.each do |key, value|
            target[key] = merge(target[key], value)
          end
          target
        else
          value_b
        end
      end

      def build(root_context, platform_context, version_context)
        merge(root_context, merge(platform_context, version_context))
      end
    end
  end
end