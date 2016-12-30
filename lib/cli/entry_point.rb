require 'pathname'
require 'gli'
require 'configuration/reader'
require 'configuration/validator'
require 'engine/api'

module Semble
  module CLI
    class EntryPoint
      include GLI::App

      attr_reader :working_directory

      gli_run = instance_method(:run)

      def initialize(working_directory)
        @working_directory = working_directory
      end

      define_method :run do |args|
        load_definitions(self.working_directory)
        gli_run.bind(self).(args)
      end

      def read_configuration(path, working_directory)
        path = Pathname.new(path)
        if path.exist?
          configuration = Semble::Configuration::Reader.new.read(path)
        else
          configuration = Semble::Configuration::Configuration.default(working_directory)
        end
        validation_result = Semble::Configuration::Validator.new.validate(configuration)
        unless validation_result[:valid]
          chunks = ['Configuration at is invalid:']
          validation_result[:violations].each do |property, violations|
            violations.each do |violation|
              chunks.push("#{property}: #{violation}")
            end
          end
          message = chunks.join("\n -")
          raise ArgumentError, message
        end
        configuration
      end

      def load_definitions(working_directory)
        program_desc 'Tool for assembling versioned filesets, e.g. Docker image contexts for different product versions'
        spec = Gem::Specification.load(File.expand_path('../../semble.gemspec', __dir__))
        version spec.version
        flag [:c, :config, :configuration], :default_value => File.join(working_directory, 'semble.yml')

        command :build do |c|
          c.action do |globals, options, args|
            build(globals[:c], *args)
          end
        end

        default_command :build
      end
    end
  end
end