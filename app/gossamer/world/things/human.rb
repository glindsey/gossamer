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
                abdomen:   {},
                left_arm:  {
                  type:  :arm,
                  tags:  [:left],
                  parts: {
                    left_hand: {
                      type: :hand
                    }
                  }
                },
                right_arm: {
                  type:  :arm,
                  tags:  [:right],
                  parts: {
                    right_hand: {
                      type: :hand
                    }
                  }
                },
                head:      {},
                left_leg:  {
                  parts: {
                    left_foot: {
                      type: :foot
                    }
                  }
                },
                right_leg: {
                  parts: {
                    right_foot: {
                      type: :foot
                    }
                  }
                },
                torso:     {}
              },
              tags:  [:human]
            }
          end
        end
      end
    end
  end
end
