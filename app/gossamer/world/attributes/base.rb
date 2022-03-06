# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Attributes
      # Base class for attributes.
      class Base
        include World::Traits::HasProperties
      end
    end
  end
end
