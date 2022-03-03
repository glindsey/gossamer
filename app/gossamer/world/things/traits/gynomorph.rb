# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Gynomorph means "possessing female sexual characteristics".
        module Gynomorph
          extend ActiveSupport::Concern

          included do
            global_properties.merge!({ gynomorphic: true })
          end

          # TODO: write me
        end
      end
    end
  end
end
