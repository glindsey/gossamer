# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Attributes
      class Circle < Shape
        include World::Traits::Concrete
      end
    end
  end
end
