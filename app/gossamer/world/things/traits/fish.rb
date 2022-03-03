# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a fish.
        module Fish
          extend ActiveSupport::Concern
          include Things::Traits::Dimorph

          included do
            global_properties.merge!({ piscine: true })
          end

          # TODO: write me
        end
      end
    end
  end
end
