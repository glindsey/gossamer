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

          def class_default_parts
            super.deep_merge(
              {
                left_arm:  {},
                right_arm: {},
                torso:     {},
                abdomen:   {},
                head:      {}
              }
            )
          end
        end
      end
    end
  end
end
