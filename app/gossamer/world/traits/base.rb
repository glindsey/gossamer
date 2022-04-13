# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Definition of the "base" trait. Since traits are modules, there is no
      # inheritance with them; instead, they should have
      # `extend World::Traits::Base` at the top of the module definition.
      module Base
        def self.extended(mod)
          mod.module_exec do
            extend ActiveSupport::Concern
            include Concerns::Log
          end
        end
      end
    end
  end
end
