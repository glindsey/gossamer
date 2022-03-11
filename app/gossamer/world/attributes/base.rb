# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Attributes
      # Base class for attributes.
      class Base
        include World::Traits::HasProperties

        def initialize
          raise 'Attributes are static and cannot be instantiated'
        end
      end
    end
  end
end
