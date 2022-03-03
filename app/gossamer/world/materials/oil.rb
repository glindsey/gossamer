# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Oil < Liquid
        include Materials::Traits::Flammable

        # has_refs: material: burn_result: smoke
      end
    end
  end
end
