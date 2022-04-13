# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of an amphibian.
        module Amphibian
          include World::Traits::Base
          include Things::Traits::Polymorph

          class_methods do
            def amphibian?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
