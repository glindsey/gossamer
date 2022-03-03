# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Attributes
      # Definition of a square shape.
      class Square < Polygon
        include World::Traits::Concrete
      end
    end
  end
end
