# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # A quadruped has left-front, left-rear, right-front, and right-rear
        # legs by default.
        module Quadruped
          include World::Traits::Base
          using Refinements::AssemblyInstructions

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                opts.add_part(
                  to:    [:abdomen],
                  parts: {
                    left_rear_leg:  { type: :leg, tags: [:left]  },
                    right_rear_leg: { type: :leg, tags: [:right] }
                  }
                )

                opts.add_part(
                  to:    [:torso],
                  parts: {
                    left_front_leg:  { type: :leg, tags: [:left]  },
                    right_front_leg: { type: :leg, tags: [:right] }
                  }
                )
              }
            )
          end

          class_methods do
            def quadrupedal?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
