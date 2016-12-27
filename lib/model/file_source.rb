module Semble
  module Model
    class FileSource
      attr_accessor :path
      attr_accessor :origin
      attr_accessor :type

      class Origin
        attr_accessor :platform
        attr_accessor :version
        attr_accessor :path
      end
    end
  end
end