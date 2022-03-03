# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Bone < Solid
        include World::Traits::Concrete
        include Materials::Traits::Burnable
        include Materials::Traits::Cookable
        include Materials::Traits::Organic
      end
    end
  end
end
