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
          smart_merge(
            self.class.properties,
            smart_merge(
              defined?(super) ? super : {},
              local_properties
            )
          )
        end

        def create_properties_from(options)
          return unless options.key?(:properties)

          props = options[:properties]

          case props
          when Array
            props = props.to_h { |prop| [prop, true] }
          when Hash
            # do nothing
          else
            props = { props => true }
          end

          local_properties.merge!(props)
        end

        class_methods do
          def properties
            (defined?(super) ? super : { abstract: true })
              .merge(global_properties)
          end

          def global_properties
            @global_properties ||= {}
          end
        end
      end
    end
  end
end
