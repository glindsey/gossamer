# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Relations
        # "A wields B" -- one-to-many relationship, exclusive of other "holds"
        # relations
        class Wields < Holds; end
      end
    end
  end
end
