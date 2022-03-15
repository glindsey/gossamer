# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Global mixin for things that can be instantiated.
      # This does NOT mean they are "concrete" in a physical sense, only that
      # they can exist as independent objects.
      module Concrete
        extend ActiveSupport::Concern

        class_methods do
          def abstract?
            false
          end
        end
      end
    end
  end
end
