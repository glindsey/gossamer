# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a reptile.
        module Reptile
          extend ActiveSupport::Concern
          include Things::Traits::Dimorph

          class_methods do
            def reptilian?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end