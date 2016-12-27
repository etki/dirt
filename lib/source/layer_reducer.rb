module Semble
  module Source
    class LayerReducer
      def reduce(*layers)
        entries = {}
        layers.each do |layer|
          layer.entries.each do |key, entry|
            entries[key] = entry
          end
          layers.whiteouts.each do |whiteout|
            entries.delete(whiteout)
          end
        end
        entries
      end
    end
  end
end