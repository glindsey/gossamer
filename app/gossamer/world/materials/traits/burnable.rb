# frozen_string_literal: true

module Gossamer
  module World
    module Materials
      module Traits
        # Burnable indicates a substance that can burn.
        # It may also have a flash point.
        module Burnable
          include World::Traits::Base

          # has_attributes: burn_percentage, flash_point*
          # has_refs: material: burn_result
        end
      end
    end
  end
end
