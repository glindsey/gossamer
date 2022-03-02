# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Bronze < Alloy
        include ::Gossamer::World::Traits::Concrete
        include ::Gossamer::World::Materials::Traits::Oxidizable
      end
    end
  end
end

