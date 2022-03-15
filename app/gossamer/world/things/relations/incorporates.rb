# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Relations
        # "A incorporates B" -- one-to-many relationship, exclusive of other
        # "holds" relations
        class Incorporates < Holds; end
      end
    end
  end
end
