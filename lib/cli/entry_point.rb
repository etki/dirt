require 'pathname'
require 'logger'
require 'gli'
require 'semble'
require 'logging/logger_factory'
require 'model/configuration/bootstrap'
require 'bootstrap/container_builder'

module Semble
  module CLI
    class EntryPoint
      include GLI::App

      def initialize
        @logger = Semble::Logging::LoggerFactory.get(self.class)
      end

      gli_run = instance_method(:run)

      define_method :run do |args|
        register
        gli_run.bind(self).(args)
      end

      def register
        program_desc 'Tool for assembling versioned filesets, e.g. Docker image contexts for different product versions'
        version Semble::VERSION
        flag [:c, :config, :configuration], :default_value => 'semble.yml'
        flag [:w, :'working-directory'], :default_value => nil
        # Currently there's no time to play with files. Next release, maybe.
        # flag [:'log-target'], :default_value => nil
        flag [:'log-threshold'], :default_value => 'info'

        command :build do |c|
          c.action do |globals, options, args|
            wrap do
              initialize_container(globals)
              if args.empty?
                report = @container.api.build_all
              else
                report = @container.api.build(args.map {|arg| Semble::Model::API::BuildRequest.from_string(arg) })
              end
              process_result(report.exceptions)
            end
          end
        end

        default_command :build
      end

      def wrap
        begin
          yield
        rescue Exception => e
          process_result([e])
        end
      end

      private
      def initialize_container(flags)
        config = Semble::Model::Configuration::Bootstrap.new
        config.log_threshold = flags['log-threshold']
        config.log_target = STDOUT
        working_directory = Pathname.new(Dir.pwd)
        working_directory = working_directory.join(flags[:w]) if flags[:w]
        config.working_directory = working_directory
        config.configuration_file = working_directory.join(flags[:c])
        @container = Semble::Bootstrap::ContainerBuilder.new.bootstrap(config, nil)
      end

      # @param [Array<Exception>] exceptions
      # @param [Integer] exit_code
      def process_result(exceptions = [], exit_code = nil)
        if exceptions.empty?
          @logger.info('Operation successfully completed')
          exit_code = 0 unless exit_code
        else
          @logger.error('Operation has completed unsuccessfully')
          @logger.error('Encountered exceptions:')
          exceptions.each do |exception|
            @logger.error("- #{exception}")
            exception.backtrace.each do |line|
              @logger.error("  #{line}")
            end
          end
          exit_code = 1 unless exit_code
        end
        exit_code
      end
    end
  end
end