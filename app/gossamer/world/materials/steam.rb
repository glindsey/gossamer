# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      class Steam < Gas
        # has_refs:
        #     materials:
        #       deposit_result: frost
        #       condense_result: dew
      end
    end
  end
end
