# frozen_string_literal: true

module Gossamer
  module World
    module Materials
      module Traits
        # Oxidizable is any substance that rusts/tarnishes/etc.
        module Oxidizable
          include World::Traits::Base

          # has_attributes: oxidation_percentage
          # has_refs: material: oxidize_result
        end
      end
    end
  end
end
