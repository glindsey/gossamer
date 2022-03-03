# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a mammal.
        module Mammal
          extend ActiveSupport::Concern
          include Things::Traits::Dimorph

          included do
            global_properties.merge!({ mammalian: true })
          end

          # TODO: write me
        end
      end
    end
  end
end
