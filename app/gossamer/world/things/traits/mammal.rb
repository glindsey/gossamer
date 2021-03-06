# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a mammal.
        module Mammal
          include World::Traits::Base
          include Things::Traits::Polymorph
          using Refinements::AssemblyInstructions

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                # A mammal typically has two eyes, a nose, and a mouth.
                # TODO: Forward-facing or side-facing depending on prey or
                #       predator
                opts.add_part(
                  to: [:head],
                  parts: {
                    left_ear:  { type: :ear, tags: [:left] },
                    right_ear: { type: :ear, tags: [:right] },
                    left_eye:  { type: :eye, tags: [:left] },
                    right_eye: { type: :eye, tags: [:right] },
                    nose:      {},
                    mouth:     {}
                  }
                )
              }
            )
          end

          class_methods do
            def mammalian?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
