module Semble
  module Utility
    class Hash
      # todo: clone support?
      def self.deep_merge(hash_a, hash_b)
        if hash_a.is_a?(::Hash) and hash_b.is_a?(::Hash)
          result = hash_a.clone
          hash_b.each do |key, value|
            result[key] = Hash.deep_merge(result[key], value)
          end
          return result
        end
        if not hash_b.nil?
          hash_b
        else
          hash_a
        end
      end
    end
  end
end