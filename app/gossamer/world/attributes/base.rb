# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Attributes
      # Base class for attributes.
      class Base
        include World::Traits::HasProperties

        def is?(prop)
          properties.fetch(prop, false)
        end

        def not?(prop)
          !is?(prop)
        end

        class << self
          def is?(prop)
            properties.fetch(prop, false)
          end

          def not?(prop)
            !is?(prop)
          end
        end
      end
    end
  end
end
