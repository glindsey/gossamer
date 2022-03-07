# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # A quadruped has left-front, left-rear, right-front, and right-rear
        # legs by default.
        module Quadruped
          include Concerns::SmartMerge
          extend ActiveSupport::Concern

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                smart_merge(
                  opts,
                  {
                    parts: {
                      left_front_leg:  { type: :leg },
                      left_rear_leg:   { type: :leg },
                      right_front_leg: { type: :leg },
                      right_rear_leg:  { type: :leg }
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
