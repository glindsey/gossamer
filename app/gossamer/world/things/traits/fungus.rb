# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a fungus.
        module Fungus
          extend ActiveSupport::Concern

          included do
            global_properties.merge!({ fungal: true })
          end

          # TODO: write me
        end
      end
    end
  end
end
