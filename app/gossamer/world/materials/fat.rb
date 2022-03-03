# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Fat < Solid
        include World::Traits::Concrete
        include Materials::Traits::Cookable
        include Materials::Traits::Flammable
        include Materials::Traits::Meltable
        include Materials::Traits::Organic
      end
    end
  end
end
