module Semble
  module Processing
    class Entry
      attr_accessor :source
      attr_accessor :target
      attr_accessor :content
      attr_accessor :platform
      attr_accessor :version
      # :binary or :template
      attr_accessor :type
    end
  end
end