require 'configuration/parser'

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
          printed_exception = "#{e}\n#{e.backtrace.join("\n")}"
          message = "Could not read Semble config at `#{location}`, original exception: \n#{printed_exception}"
          raise ArgumentError, message
        end
      end
    end
  end
end