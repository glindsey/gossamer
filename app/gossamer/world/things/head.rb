# frozen_string_literal: true

module Gossamer
  module World
    module Things
      class Head < BodyPart
        include World::Traits::Concrete
      end
    end
  end
end
