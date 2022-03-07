# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that a class and its instantiated objects have a material that
      # can be read/written/queried.
      module HasMaterial
        extend ActiveSupport::Concern
        include Concerns::SymbolToGossamerClass
        using Refinements::ObjectToKeysOfHash

        def material
          @material ||= self.class.default_material # no deep_dup needed here
        end

        def material=(mat)
          @material = materialify(mat)
        end

        def material?
          !material.nil?
        end

        class_methods do
          attr_reader :default_material

          def default_material=(mat)
            @default_material = materialify(mat)
          end

          def default_material?
            !default_material.nil?
          end
        end
      end
    end
  end
end
