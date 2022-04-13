# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a plant.
        module Plant
          include World::Traits::Base

          class_methods do
            def vegetative?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
