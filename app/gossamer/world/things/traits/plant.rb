# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a plant.
        module Plant
          extend ActiveSupport::Concern

          included do
            global_properties.merge!({ vegetative: true })
          end

          # TODO: write me
        end
      end
    end
  end
end
