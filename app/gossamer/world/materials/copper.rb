# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Copper < Metal
        include ::Gossamer::World::Traits::Concrete
        include ::Gossamer::World::Materials::Traits::Oxidizable
      end
    end
  end
end

