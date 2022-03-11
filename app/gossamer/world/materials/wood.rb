# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Materials
      class Wood < Solid
        include World::Traits::Concrete
        include Materials::Traits::Flammable
        include Materials::Traits::Organic
      end
    end
  end
end
