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
            mixin_config_funcs_after.append(
              lambda { |opts|
                smart_merge(
                  opts,
                  {
                    properties: {
                      steve: true
                    },
                    parts:      {
                      left_leg:  {},
                      right_leg: {}
                    }
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
