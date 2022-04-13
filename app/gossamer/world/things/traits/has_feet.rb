# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a being that has feet at the ends of its legs.
        module HasFeet
          extend World::Traits::Base

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                # Get refs to torso and abdomen.
                torso = opts.dig(:parts, :torso)
                abdomen = opts.dig(:parts, :abdomen)

                if [torso, abdomen].all?(&:blank?)
                  Services::Logger.log(
                    'While trying to add feet: ' \
                    "#{inspect} does not have a torso or abdomen!",
                    level: :warning
                  )

                  return opts
                end

                [torso, abdomen].each do |big_part|
                  # Iterate through all legs attached to this part.

                  parts = big_part.fetch(:parts, nil)

                  next unless parts

                  parts.each do |(part_name, part)|
                    parts[part_name] =
                      smart_merge(part, { parts: { foot: {} } })
                  end
                end

                opts
              }
            )
          end

          class_methods do
            def feet?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
