# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a being that has hands at the ends of its arms.
        module HasHands
          include World::Traits::Base
          include Concerns::Log
          using Refinements::SmartMerge

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                # Iterate through all arms attached to this being's torso.
                torso = opts.dig(:parts, :torso)

                unless torso
                  Services::Logger.log(
                    'While trying to add hands: ' \
                    "#{inspect} does not have a torso!",
                    level: :warning
                  )

                  return opts
                end

                torso_parts = torso.fetch(:parts, nil)

                unless torso_parts
                  Services::Logger.log(
                    'While trying to add hands: ' \
                    "#{inspect}'s torso does not have parts!",
                    level: :warning
                  )

                  return opts
                end

                torso_parts.each do |(part_name, part)|
                  torso_parts[part_name] =
                    part.smart_merge({ parts: { hand: {} } })
                end

                opts
              }
            )
          end

          class_methods do
            def hands?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
