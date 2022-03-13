# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # A typical room, consisting of a floor, ceiling, and a number of walls.
      # The "material" of a room is what is filled with; this is usually "air",
      # but could be "water" or some other substance, or even "vacuum".
      #
      # TODO: Derive from Container?
      #
      class Room < Base
        include World::Traits::Concrete

        class << self
          def default_material
            Materials::Air
          end
        end
      end
    end
  end
end
