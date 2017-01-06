require 'engine/render/liquid'
require 'engine/file_system'
require 'engine/api'

module Semble
  module Engine
    class Container

      attr_accessor :configuration
      attr_accessor :filesystem_driver
      attr_accessor :schema

      def logger_factory
        wrap :logger_factory do
          Semble::Logging::LoggerFactory.new(configuration.log_target, configuration.log_threshold)
        end
      end

      def build_plan_factory
        wrap :build_plan_factory do
          Semble::API::Build::PlanFactory.new(schema)
        end
      end

      def build_plan_executor
        wrap :build_plan_executor do
          Semble::Engine::Build::PlanExecutor.new(filesystem, render_engine)
        end
      end

      def api
        wrap :api do
          Semble::Engine::API.new(self)
        end
      end

      def render_engine
        wrap :render_engine do
          Semble::Engine::Rendering::Engine.new
        end
      end

      def filesystem
        wrap(:filesystem) do
          Semble::Engine::FileSystem.new(filesystem_driver)
        end
      end

      def drop(component)
        instance_variable_set('@' + component.to_s, nil)
      end

      private
      def wrap(name, &block)
        name = '@' + name.to_s
        unless instance_variable_get(name)
          instance_variable_set(name, block.call)
        end
        instance_variable_get(name)
      end
    end
  end
end