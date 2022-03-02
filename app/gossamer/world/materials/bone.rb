# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Bone < Solid
        include ::Gossamer::World::Traits::Concrete
        include ::Gossamer::World::Materials::Traits::Burnable
        include ::Gossamer::World::Materials::Traits::Cookable
        include ::Gossamer::World::Materials::Traits::Organic
      end
    end
  end
end

