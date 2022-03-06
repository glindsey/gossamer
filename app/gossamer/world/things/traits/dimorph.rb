# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Dimorph means both "possibly having male or female sexual
        # characteristics", as opposed to identifying as a particular gender.
        module Dimorph
          extend ActiveSupport::Concern

          class_methods do
            def dimorphic?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
