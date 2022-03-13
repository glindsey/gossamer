# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # A wall of a room or other area.
      class Wall < Surface
        include World::Traits::Concrete
        include World::Traits::Fixed
      end
    end
  end
end
