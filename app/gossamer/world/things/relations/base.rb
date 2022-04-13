# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Relations
        # Base class for a relation between two things.
        class Base
          def initialize(id, thing_a, thing_b, pool:)
            @id = id
            @thing_a = thing_a
            @thing_b = thing_b
            @pool = pool
          end
        end
      end
    end
  end
end
