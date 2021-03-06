# frozen_string_literal: true

module Gossamer
  module World
    module Materials
      module Traits
        # Corrodable is any substance that can corrode.
        module Corrodable
          include World::Traits::Base

          # has_attributes: corrosion
          # has_refs: material: corrode_result
        end
      end
    end
  end
end
