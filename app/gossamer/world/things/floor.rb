# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # The floor of a room or other area.
      class Floor < Surface
        include World::Traits::Concrete
        include World::Traits::Fixed
      end
    end
  end
end
