module Semble
  module Model
    module API
      # Used to wrap up all produced build reports
      class AggregateBuildReport
        # @type Hash<Semble::Model::ImageId, Semble::Model::BuildReport>
        attr_accessor :reports
        attr_accessor :start_time
        attr_accessor :end_time

        def initialize(&block)
          @reports = {}
          block.call(self) if block_given?
        end

        def successful_reports
          reports.values.select(&:successful)
        end

        def failed_reports
          reports.values.select { |report| not report.successful }
        end

        def successful
          failed_reports.empty?
        end

        def add_report(report)
          reports[report.image_id] = report
          self
        end

        # Returns all encountered exceptions as a hash of image id and exception encountered
        #
        # @return Hash{Semble::Model::ImageId => Exception}
        def exceptions
          pairs = reports.values.select do |report|
            not report.successful
          end .map do |report|
            [report.image_id, report.exception]
          end
          Hash[pairs]
        end
      end
    end
  end
end