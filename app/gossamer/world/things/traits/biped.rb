# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # A biped has a left leg and a right leg by default.
        module Biped
          extend ActiveSupport::Concern

          included do
            global_properties[:bipedal] = true

            mixin_parts.deep_merge!(
              {
                left_leg:  {},
                right_leg: {}
              }
            )
          end

          # TODO: write me
        end
      end
    end
  end
end
