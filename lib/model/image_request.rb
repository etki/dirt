require 'model/version'

module Semble
  module Model
    class ImageRequest
      attr_accessor :platform
      attr_accessor :version
      attr_accessor :context

      def initialize(platform = nil, version = nil, context = {}, &block)
        @platform = platform
        @version = version
        @context = context
        block.call(self) if block
      end

      def self.from_string(input)
        input.strip!
        ImageRequest.new do |request|
          if input.include?(':')
            position = input =~ /:/
            request.platform = input[0, position].strip
            version_chunk = input[position + 1, input.length - position].strip
            request.version = Semble::Model::Version.new(version_chunk)
          else
            request.version = Semble::Model::Version.new(input)
          end
        end
      end
    end
  end
end