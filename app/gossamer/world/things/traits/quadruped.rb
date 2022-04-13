# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # A quadruped has left-front, left-rear, right-front, and right-rear
        # legs by default.
        module Quadruped
          include World::Traits::Base
          using Refinements::SmartMerge

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                opts.smart_merge(
                  {
                    parts: {
                      left_front_leg:  {
                        type: :leg,
                        tags: %i[left front]
                      },
                      left_rear_leg:   {
                        type: :leg,
                        tags: %i[left rear]
                      },
                      right_front_leg: {
                        type: :leg,
                        tags: %i[right front]
                      },
                      right_rear_leg:  {
                        type: :leg,
                        tags: %i[right rear]
                      }
                    }
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
