# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Andromorph means "possessing male sexual characteristics".
        module Andromorph
          extend ActiveSupport::Concern

          class_methods do
            def andromorphic?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
