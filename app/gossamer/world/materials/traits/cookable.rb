# frozen_string_literal: true

module Gossamer
  module World
    module Materials
      module Traits
        # Cookable is any substance that can be cooked.
        module Cookable
          extend World::Traits::Base

          # has_attributes: cooked_percentage
        end
      end
    end
  end
end
