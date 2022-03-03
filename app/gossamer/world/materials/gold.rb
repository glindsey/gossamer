# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Materials
      # Definition of gold as a material.
      class Gold < Metal
        include World::Traits::Concrete
      end
    end
  end
end
