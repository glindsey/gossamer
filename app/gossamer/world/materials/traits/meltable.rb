# frozen_string_literal: true

module Gossamer
  module World
    module Materials
      module Traits
        # Meltable indicates a substance that can melt, versus one that only
        # burns.
        module Meltable
          extend ActiveSupport::Concern

          # has_attributes: melting_point, sublimation_point
        end
      end
    end
  end
end
