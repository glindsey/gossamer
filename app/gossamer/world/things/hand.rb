# frozen_string_literal: true

module Gossamer
  module World
    module Things
      class Hand < BodyPart
        include World::Traits::Concrete
        include Things::Traits::Prehensile
      end
    end
  end
end
