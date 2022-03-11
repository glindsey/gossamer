# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # Describes the mouth of a being.
      class Mouth < BodyPart
        include World::Traits::Concrete

        def self.severable?
          false
        end
      end
    end
  end
end
