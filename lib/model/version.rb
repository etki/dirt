module Semble
  module Model
    class Version
      include Comparable

      SPLIT_PATTERN = /^(?:(\d+))?(?:\.(\d+))?(?:\.(\d+))?(?:\.(\d+))?(?:-?([\w\d]+))?/
      PART_NAMES = [:major, :minor, :patch, :build]
      PART_NAMES.each do |name|
        attr_accessor name
      end
      attr_accessor :classifier

      def initialize(input)
        return unless input
        match = SPLIT_PATTERN.match(input)
        return unless match
        @major = Version.integerify match[1]
        @minor = Version.integerify match[2]
        @patch = Version.integerify match[3]
        @build = Version.integerify match[4]
        @classifier = match[5]
      end

      def normalize!
        PART_NAMES.each do |name|
          variable = ('@' + name.to_s).to_sym
          instance_variable_set(variable, (instance_variable_get(variable) or 0))
        end
        self
      end

      def normalize
        clone.normalize!
      end

      # Removes last version part (classifier, then build, then patch, etc.) and returns it. in case all parts are set
      # to nil, returns nil
      def shorten!
        if @classifier
          @classifier = nil
          return self
        end
        i = 3
        while i >= 0
          part = PART_NAMES[i]
          variable = ('@' + part.to_s).to_sym
          i -= 1
          next if instance_variable_get(variable).nil?
          instance_variable_set(variable, nil)
          return self
        end
        nil
      end

      def shorten
        clone.shorten!
      end

      def to_s
        accumulator = nil
        PART_NAMES.each do |name|
          variable = ('@' + name.to_s).to_sym
          chunk = instance_variable_get(variable)
          if chunk
            if accumulator
              accumulator += '.' + chunk.to_s
            else
              accumulator = chunk.to_s
            end
          end
        end
        if classifier
          if accumulator
            accumulator += '-' + classifier
          else
            accumulator = classifier
          end
        end
        accumulator
      end

      def <=>(other)
        i = 0
        until i > 3
          sym = ('@' + PART_NAMES[i].to_s).to_sym
          self_part = (self.instance_variable_get(sym) or 0)
          other_part = (other.instance_variable_get(sym) or 0)
          result = self_part <=> other_part
          return result if result != 0
          i += 1
        end
        classifier <=> other.classifier
      end

      private
      def self.integerify(string_or_null)
        if string_or_null
          string_or_null.to_i
        else
          nil
        end
      end
    end
  end
end