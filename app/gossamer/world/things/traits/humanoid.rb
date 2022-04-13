# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # "Humanoid" implies that a thing will have two legs, two arms, a torso,
        # an abdomen, and a head when created.
        module Humanoid
          include World::Traits::Base
          include Things::Traits::Biped

          class_methods do
            def humanoid?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
