# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Global mixin for things that can be instantiated.
      module Concrete
        extend ActiveSupport::Concern
        include World::Traits::HasProperties

        included do
          global_properties[:abstract] = false
        end
      end
    end
  end
end
