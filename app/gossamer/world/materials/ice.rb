# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Ice < Solid
        include ::Gossamer::World::Materials::Traits::Meltable

        # has_refs:
        #   materials:
        #     sublimate_result: steam
        #     melt_result: water
      end
    end
  end
end

