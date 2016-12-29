module Semble
  module Configuration
    class Reader
      def read(location)
        location = Pathname.new(location)
        begin
          base_path = location.dirname
          raw = location.read
          Semble::Configuration::Parser.new.parse(raw, base_path)
        rescue Exception => e
          raise ArgumentError, "Could not read Semble config at `#{location}`, original exception: #{e}"
        end
      end
    end
  end
end