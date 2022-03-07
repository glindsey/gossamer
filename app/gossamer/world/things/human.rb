# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # Definition of a human.
      class Human < Lifeform
        include World::Traits::Concrete
        include Traits::Humanoid
        include Traits::Mammal

        class << self
          def default_config
            {
              parts: {
                left_arm:  {
                  type: :arm,
                  tags: [:left]
                },
                right_arm: {
                  type: :arm,
                  tags: [:right]
                },
                torso:     {},
                abdomen:   {},
                head:      {}
              },
              tags:  [:human]
            }
          end
        end
      end
    end
  end
end
