require 'set'

module Semble
  module Model
    module Blueprints
      class SourceSet
        # @!attribute [rw] id
        #   @return [Semble::Model::Id]
        attr_accessor :id
        # @!attribute [rw] directory
        #   @return [Pathname]
        attr_accessor :directory
        # @!attribute [rw] entries
        #   @return [Hash<Pathname, Semble::Model::Blueprints::FileSource>]
        attr_accessor :entries
        # @!attribute [rw] whiteouts
        #   @return [Set<Pathname>]
        attr_accessor :whiteouts
        # @!attribute [rw] context
        #   @return [Hash]
        attr_accessor :context

        def initialize(id = nil, directory = nil)
          self.id = id
          self.directory = directory
          self.entries = {}
          self.whiteouts = ::Set.new
          self.context = {}
        end

        def to_s
          "Source set `#{id}`, entries: #{entries.size}, whiteouts: #{whiteouts.size}, context size: #{context.size}"
        end
      end
    end
  end
end