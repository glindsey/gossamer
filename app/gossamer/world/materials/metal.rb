# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Metal < Solid
        include ::Gossamer::World::Materials::Traits::Meltable

        # has_traits: ductile, malleable, shiny
      end
    end
  end
end

