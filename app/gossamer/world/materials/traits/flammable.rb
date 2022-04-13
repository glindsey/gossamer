# frozen_string_literal: true

module Gossamer
  module World
    module Materials
      module Traits
        # Flammable indicates a substance that not only burns, but also has a
        # flash point where it spontaneously bursts into flame.
        module Flammable
          include World::Traits::Base
          include Materials::Traits::Burnable

          # has_attributes: flash_point
        end
      end
    end
  end
end
