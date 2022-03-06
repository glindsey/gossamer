# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a mammal.
        module Mammal
          extend ActiveSupport::Concern
          include Things::Traits::Dimorph

          included do
            global_properties[:mammalian] = true

            mixin_config_funcs_after.append(
              lambda { |opts|
                # A mammal typically has two eyes.
                # TODO: Forward-facing or side-facing depending on prey or
                #       predator
                head = opts.dig(:parts, :head)
                if head
                  opts[:parts][:head] = smart_merge(head,
                                                    {
                                                      parts: {
                                                        left_eye:  {},
                                                        right_eye: {}
                                                      }
                                                    })
                else
                  warn "!!! Mammal #{inspect} does not have a head!"
                end

                opts
              }
            )
          end

          # TODO: write me
        end
      end
    end
  end
end
