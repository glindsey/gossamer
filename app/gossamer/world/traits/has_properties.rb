# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that a class and its instantiated objects have properties that
      # can be read/written/queried. Properties are always boolean true/false
      # values.
      # Object properties are saved as a hash of keys to booleans.
      # Class properties, on the other hand, are implemented as class methods
      # that return true/false values.
      # When a property is requested, it is looked up via the following rules:
      # - Return the requested object property if it exists
      # - Return the requested class property if it exists
      # - Return false
      #
      # By default, the "abstract" property is set on any class including this
      # trait.
      module HasProperties
        extend World::Traits::Base
        using ::Gossamer::Refinements::ObjectToKeysOfHash

        def properties
          @properties ||= {}
        end

        def property_exists?(prop)
          properties.key?(prop) ||
            self.class.respond_to?("#{prop}?".to_sym)
        end

        def property?(prop)
          return properties[prop] if properties.key?(prop)

          meth_sym = "#{prop}?".to_sym

          return self.class.send(meth_sym) if self.class.respond_to?(meth_sym)

          false
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

          properties.merge!(props)
        end

        # Default implementation; checks object properties, and then class
        # properties.
        def is?(prop)
          properties.fetch(prop,
                           self.class.is?(prop))
        end

        def not?(prop)
          !is?(prop)
        end

        class_methods do
          def abstract?
            true
          end

          def is?(prop)
            meth_sym = "#{prop}?".to_sym

            respond_to?(meth_sym) ? send(meth_sym) : false
          end

          def not?(prop)
            !is?(prop)
          end
        end
      end
    end
  end
end
