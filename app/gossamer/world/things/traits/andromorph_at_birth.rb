# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Andromorph means "possessing male sexual characteristics".
        module AndromorphAtBirth
          extend World::Traits::Base

          class_methods do
            def andromorphic_at_birth?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
