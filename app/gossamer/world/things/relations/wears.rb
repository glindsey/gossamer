# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Relations
        # "A wears B" -- one-to-many relationship, exclusive of other "holds"
        # relations
        class Wears < Holds; end
      end
    end
  end
end
