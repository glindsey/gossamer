# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Attributes
      module Shapes
        # Definition of a square shape.
        class Square < Polygon
          include World::Traits::Concrete
        end
      end
    end
  end
end
