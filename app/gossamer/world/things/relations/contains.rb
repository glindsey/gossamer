# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Relations
        # "A contains B" -- one-to-many relationship, exclusive of other "holds"
        # relations
        class Contains < Holds; end
      end
    end
  end
end
