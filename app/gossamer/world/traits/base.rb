# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Definition of the "base" trait. Since traits are modules, there is no
      # inheritance with them; instead, they should have
      # `include World::Traits::Base` at the top of the module definition.
      module Base
        extend ActiveSupport::Concern
        include Concerns::Log
        using Refinements::AssemblyInstructions
        using Refinements::SmartMerge

        included do
          extend ActiveSupport::Concern
          include Concerns::Log
          using Refinements::AssemblyInstructions
          using Refinements::SmartMerge
        end
      end
    end
  end
end
