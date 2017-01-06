module Semble
  module Model
    module Blueprints
      class Schema
        # @!attribute [rw] targets
        #   @return [Hash<Symbol, Hash<Semble::Model::Id, Semble::Model::Blueprints::Target>>]
        attr_accessor :targets
        # @!attribute [rw] sources
        #   @return [Hash<Symbol, Hash<Semble::Model::Id, Semble::Model::Blueprints::Set>>]
        attr_accessor :source_sets

        def initialize
          @sources = {}
          @targets = {}
        end

        # @param [Semble::Model::Blueprints::Target] target
        def add_target(target)
          @targets[target.id.platform] = {} unless @targets[target.id.platform]
          @targets[target.id.platform][target.id.version] = target
        end

        # @param [Array<Semble::Model::Blueprints::Target>] targets
        def add_targets(*targets)
          targets.map { |target| add_target(target) }
        end

        # @param [Semble::Model::Blueprints::Set] source_set
        def add_source_set(source_set)
          @sources[source_set.id.platform] = {} unless @sources[source_set.id.platform]
          @sources[source_set.id.platform][source_set.id.version] = source_set
        end

        # @param [Array<Semble::Model::Blueprints::Set>] source_sets
        def add_source_sets(*source_sets)
          source_sets.map { |set| add_source_set(set) }
        end

        # @param [Symbol] platform
        # @param [Semble::Model::Version] uppermost_version
        # @return [Hash<Semble::Model::Id, Semble::Model::Blueprints::Set>]
        def get_source_set_slice(platform, uppermost_version)
          pool = (@sources[platform] or {})
          pool.select { |version| version <= uppermost_version }
        end
      end
    end
  end
end