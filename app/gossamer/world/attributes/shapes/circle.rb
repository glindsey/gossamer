# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Attributes
      module Shapes
        class Circle < Round
          include World::Traits::Concrete
        end
      end
    end
  end
end
