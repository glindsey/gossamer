# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Global mixin for a thing that is fixed in place, and can't be moved from
      # its location within its container.
      module Fixed
        extend World::Traits::Base
        include World::Traits::HasProperties

        class_methods do
          def fixed?
            true
          end
        end
      end
    end
  end
end
