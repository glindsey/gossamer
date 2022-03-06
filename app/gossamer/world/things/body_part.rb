# frozen_string_literal: true

module Gossamer
  module World
    module Things
      # Definition of a part of a lifeform's body.
      class BodyPart < Base
        class << self
          def severable?
            true
          end
        end
      end
    end
  end
end
