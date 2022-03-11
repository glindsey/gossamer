# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Materials
      # Base class for materials.
      class Base
        include World::Traits::HasAttributes
        include World::Traits::HasProperties
      end
    end
  end
end
