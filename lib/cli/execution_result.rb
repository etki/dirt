module Semble
  module CLI
    class ExecutionResult
      attr_accessor :success
      attr_accessor :errors
      attr_accessor :suggested_exit_code

      def initialize(errors = [], suggested_exit_code = nil, &block)
        @success = errors.empty?
        @errors = errors
        @suggested_exit_code = suggested_exit_code
        block.call(self) if block
      end
    end
  end
end