# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Oil < Liquid
        include ::Gossamer::World::Materials::Traits::Burnable

        # has_refs: material: burn_result: smoke
      end
    end
  end
end

