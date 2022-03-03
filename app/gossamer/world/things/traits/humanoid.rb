# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # "Humanoid" implies that a thing will have two legs, two arms, a torso,
        # an abdomen, and a head when created.
        module Humanoid
          extend ActiveSupport::Concern
          include Things::Traits::Biped

          # TODO: write me
          included do
            # This will be at the CLASS level.

            global_properties.merge!({ humanoid: true })
          end
        end
      end
    end
  end
end
