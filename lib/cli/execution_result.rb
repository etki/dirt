module Semble
  module CLI
    class ExecutionResult
      attr_accessor :errors
      attr_accessor :suggested_exit_code

      def initialize(errors = [], suggested_exit_code = nil)
        @errors = errors
        @suggested_exit_code = suggested_exit_code
      end

      def success
        errors.empty?
      end
    end
  end
end