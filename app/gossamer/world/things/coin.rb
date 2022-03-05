# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # Definition of a coin.
      class Coin < Base
        include World::Traits::Concrete

        def default_constraints
          [
            lambda { |obj|
              shape = obj.attribute(:shape)

              unless shape&.not?(:abstract)
                "A coin must have a non-abstract shape, but #{shape.inspect} " \
                  'is abstract or missing'
              end
            },
            lambda { |obj|
              mat = obj.material
              unless mat&.not?(:abstract)
                'A coin must be made of a non-abstract material, but ' \
                  "#{mat.inspect} is abstract or missing"
              end
            }
          ]
        end
      end
    end
  end
end
