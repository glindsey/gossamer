# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a being that has feet at the ends of its legs.
        module HasFeet
          include World::Traits::Base
          using Refinements::AssemblyInstructions
          using Refinements::SmartMerge

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                opts.each_part(parts: %i[torso abdomen]) do |_, part|
                  # Iterate through all legs attached to this part.

                  subparts = part.fetch(:parts, nil)

                  next unless subparts

                  subparts.each do |(subpart_name, subpart)|
                    if subparts[subpart_name][:type] == :leg
                      subparts[subpart_name] =
                        subpart.smart_merge({ parts: { foot: {} } })
                    end
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
