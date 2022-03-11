# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Materials
      class Metal < Solid
        include Materials::Traits::Meltable

        # has_traits: ductile, malleable, shiny
      end
    end
  end
end
