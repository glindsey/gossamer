# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Global mixin for things that can be instantiated.
      module Concrete
        extend ActiveSupport::Concern
        include World::Traits::HasProperties

        def self.included(mod)
          mod.global_properties[:abstract] = false
        end

        def self.extended(mod)
          mod.local_properties[:abstract] = false
        end
      end
    end
  end
end
