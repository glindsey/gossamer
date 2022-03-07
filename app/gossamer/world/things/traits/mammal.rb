# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a mammal.
        module Mammal
          extend ActiveSupport::Concern
          include Things::Traits::Polymorph

          included do
            mixin_config_funcs_after.append(
              lambda { |opts|
                # A mammal typically has two eyes, a nose, and a mouth.
                # TODO: Forward-facing or side-facing depending on prey or
                #       predator
                head = opts.dig(:parts, :head)
                if head
                  opts[:parts][:head] =
                    smart_merge(
                      head,
                      {
                        parts: {
                          left_eye:  { type: :eye },
                          right_eye: { type: :eye },
                          nose:      {},
                          mouth:     {}
                        }
                      }
                    )
                else
                  warn "!!! Mammal #{inspect} does not have a head!"
                end

                opts
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
