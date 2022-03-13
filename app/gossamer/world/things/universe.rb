# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # The entire game world.
      class Universe < Base
        include World::Traits::Concrete
      end
    end
  end
end
