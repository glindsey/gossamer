# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a fungus.
        module Fungus
          include World::Traits::Base

          class_methods do
            def fungal?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
