# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of an insect.
        module Insect
          extend ActiveSupport::Concern
          include Things::Traits::Dimorph

          included do
            global_properties.merge!({ insectoid: true })
          end

          # TODO: write me
        end
      end
    end
  end
end
