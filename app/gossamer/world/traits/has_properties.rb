# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that a class and its instantiated objects have properties that
      # can be read/written/queried. Properties are always boolean true/false
      # values.
      # By default, the "abstract" property is set on any class including this
      # trait.
      module HasProperties
        extend ActiveSupport::Concern
        using ::Gossamer::Refinements::ObjectToKeysOfHash

        def local_properties
          @local_properties ||= {}
        end

        def property?(prop)
          properties.key?(prop) && properties[prop]
        end

        def properties
          self.class.properties.merge(local_properties).freeze
        end

        class_methods do
          def properties
            super_properties =
              if superclass.respond_to?(:properties)
                superclass.properties
              else
                { abstract: true }
              end

            super_properties.merge(global_properties).freeze
          end

          def global_properties
            @global_properties ||= {}
          end
        end
      end
    end
  end
end
