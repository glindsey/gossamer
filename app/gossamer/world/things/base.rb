# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Things
      # Definition of a basic "Thing" which all others derive from.
      class Base
        attr_accessor :material

        # Instantiation of a Thing can only be done if it is not abstract.
        def initialize(**options)
          # Mix any provided traits into the newly-created object.
          if options.key?(:traits)
            traits = options[:traits]
            traits = [traits] unless traits.is_a?(Array)
            traits.each do |trait_sym|
              trait = "::Gossamer::World::Traits::#{trait_sym.to_s.camelize}"
                      .safe_constantize

              extend(trait) if trait
            end
          end

          update_material(options)
          update_properties(options)
          update_attributes(options)

          # After all that is done, verify that the thing is not abstract.
          if is?(:abstract)
            raise "#{self.class} is abstract and cannot be instantiated"
          end

          # Call final checks on the thing.
          check_constraints
        end

        def attributes
          @attributes ||= {}
        end

        def attributes=(attrs)
          unless attrs.is_a?(Hash)
            raise "Attributes must be a Hash, but was provided #{attrs.inspect}"
          end

          @attributes = attrs
        end

        # TODO: update to include attributes from material
        def attribute(attr)
          attributes.key?(attr) ? attributes[attr] : nil
        end

        def attribute?(attr)
          attributes.key?(attr)
        end

        def constraints
          @constraints ||= []
        end

        def constraints=(cons)
          unless cons.is_a?(Array)
            raise 'Constraints must be an Array, but was provided ' \
                  "#{cons.inspect}"
          end

          @constraints = cons
        end

        def properties
          @properties ||= {}
        end

        def properties=(props)
          case props
          when Array
            @properties = props.map { |prop| [prop, true] }.to_h
          when Hash
            @properties = props
          else
            raise 'Properties must be an Array or Hash, but was provided ' \
                  "#{props.inspect}"
          end

          @properties = props
        end

        def material?
          !material.nil?
        end

        # TODO: update to include traits of material
        def is?(prop)
          return properties[prop] if properties.key?(prop)

          method_name = "#{prop}?".to_sym

          return send(method_name) if respond_to?(method_name)

          if self.class.respond_to?(method_name)
            return self.class.send(method_name)
          end

          false
        end

        def not?(prop)
          !is?(prop)
        end

        class << self
          # A Thing is abstract by default, and cannot be instantiated.
          def abstract?
            true
          end

          def is?(prop)
            method_name = "#{prop}?".to_sym

            return send(method_name) if respond_to?(method_name)

            false
          end

          def not?(prop)
            !is?(prop)
          end
        end

        private

        def check_constraints
          constraints.each do |function|
            result = function&.call(self)
            if result.is_a?(String)
              raise "Object #{inspect} failed creation constraint: #{result}"
            end
          end
        end

        def update_material(options)
          return unless options.key?(:material)

          mat = options[:material]
          if mat.is_a?(Symbol)
            mat = "::Gossamer::World::Materials::#{mat.to_s.camelize}"
                  .safe_constantize
          end

          self.material = mat
        end

        def update_attributes(options)
          return unless options.key?(:attributes)

          options[:attributes].each do |(k, v)|
            if v.is_a?(Symbol)
              v = "::Gossamer::World::Attributes::#{v.to_s.camelize}"
                  .safe_constantize
            end

            attributes[k] = v
          end
        end

        def update_properties(options)
          return unless options.key?(:properties)

          props = options[:properties]

          case props
          when Array
            props = props.map { |prop| [prop, true] }.to_h
          when Hash
            pass
          else
            props = { props => true }
          end

          properties.merge!(props)
        end
      end
    end
  end
end
