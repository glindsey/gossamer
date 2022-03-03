# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that a class and its instantiated objects have a material that
      # can be read/written/queried.
      module HasMaterial
        extend ActiveSupport::Concern
        using ::Gossamer::Refinements::ObjectToKeysOfHash

        def material
          @material ||= self.class.default_material # no deep_dup needed here
        end

        def material=(mat)
          if mat.is_a?(Symbol)
            mat = "::Gossamer::World::Materials::#{mat.to_s.camelize}"
                  .safe_constantize
          end

          @material = mat
        end

        def material?
          !material.nil?
        end

        class_methods do
          attr_reader :default_material

          def default_material=(mat)
            if mat.is_a?(Symbol)
              mat = "::Gossamer::World::Materials::#{mat.to_s.camelize}"
                    .safe_constantize
            end

            @default_material = mat
          end

          def default_material?
            !default_material.nil?
          end
        end
      end
    end
  end
end
