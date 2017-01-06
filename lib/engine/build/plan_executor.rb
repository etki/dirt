require 'logging/logger_factory'

module Semble
  module API
    module Build
      class PlanExecutor
        def initialize(render_engine, filesystem)
          @render_engine = render_engine
          @filesystem = filesystem
          @logger = Semble::Logging::LoggerFactory.get
        end

        def execute(plan)
          plan.each do |stage|
            execute_stage(stage)
          end
        end

        def execute_stage(stage)
          @logger.debug("Executing plan stage `#{stage.id}`")
          stage.actions.each do |action|
            case action.class
              when Semble::Model::Build::CopyAction
                message = "Executing copy action #{action.source_relative_path} => #{action.target_relative_path} " +
                    "in #{action.target_directory}"
                @logger.debug(message)
                @filesystem.copy(action.source_absolute_path, action.target_absolute_path)
              when Semble::Model::Build::RenderAction
                message = "Executing render action #{action.source_relative_path} => #{action.target_relative_path} " +
                    "in #{action.target_directory}"
                @logger.debug(message)
                template = @filesystem.read(action.source_absolute_path)
                content = @render_engine.render(template, action.context)
                @filesystem.write(action.target_absolute_path, content)
              else
                raise "Unknown build action class #{action.class}"
            end
          end
        end
      end
    end
  end
end