# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      # Base class for materials.
      class Base
        include World::Traits::HasProperties

        # TODO: This might not be true. We may want materials to be instantiable
        #       to handle their rusting, charring, et cetera.
        def initialize
          raise 'Materials are static and cannot be instantiated'
        end
      end
    end
  end
end
