# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Global mixin for things that can be instantiated.
      module Concrete
        extend ActiveSupport::Concern
        include World::Traits::HasProperties

        class_methods do
          def abstract?
            false
          end
        end
      end
    end
  end
end
