# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Materials
      class Iron < Metal
        include World::Traits::Concrete
        include Materials::Traits::Oxidizable
      end
    end
  end
end
