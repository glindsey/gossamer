# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # A default biped has a left leg and a right leg as part of an abdomen.
        module Biped
          include World::Traits::Base
          using Refinements::AssemblyInstructions

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                opts.add_part(
                  to:    [:abdomen],
                  parts: {
                    left_leg:  { type: :leg, tags: [:left]  },
                    right_leg: { type: :leg, tags: [:right] }
                  }
                )
              }
            )
          end

          class_methods do
            def bipedal?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
