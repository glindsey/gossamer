# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # A biped has a left leg and a right leg by default.
        module Biped
          include Concerns::SmartMerge
          extend ActiveSupport::Concern

          included do
            global_properties[:bipedal] = true

            mixin_instructions_after.append(
              lambda { |instr|
                smart_merge(instr,
                  {
                    left_leg:  {},
                    right_leg: {}
                  }
                )
              }
            )
          end

          # TODO: write me
        end
      end
    end
  end
end
