# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a fish.
        module Fish
          extend ActiveSupport::Concern
          include Things::Traits::Dimorph

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
