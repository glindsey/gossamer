# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Materials
      class Ice < Solid
        include Materials::Traits::Meltable

        # has_refs:
        #   materials:
        #     sublimate_result: steam
        #     melt_result: water
      end
    end
  end
end
