# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Definition of a prehensile part (e.g. one that can grasp things).
        module Prehensile
          include World::Traits::Base

          class_methods do
            def prehensile?
              true
            end
          end

          # TODO: write me
        end
      end
    end
  end
end
