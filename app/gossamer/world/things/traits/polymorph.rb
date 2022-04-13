# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Polymorph means "having differing morphology based on sexual genetic
        # markers", and has nothing to do with self-identified gender. (It also
        # has nothing to do with the classic roguelike/D&D "polymorph".)
        module Polymorph
          include World::Traits::Base

          class_methods do
            def polymorphic?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
