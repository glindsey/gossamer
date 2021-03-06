# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Gynomorph means "possessing female sexual characteristics".
        module GynomorphAtBirth
          include World::Traits::Base

          class_methods do
            def gynomorphic_at_birth?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
