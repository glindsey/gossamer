# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a fish.
        module Fish
          include World::Traits::Base
          include Things::Traits::Polymorph

          class_methods do
            def piscine?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
