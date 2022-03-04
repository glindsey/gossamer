# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Things
      # Definition of a basic "Thing" which all others derive from.
      class Base
        include World::Traits::HasAttributes
        include World::Traits::HasConstraints
        include World::Traits::HasMaterial
        include World::Traits::HasParts
        include World::Traits::HasProperties
        include Things::Traits::PhysicallyRelatable
        using ::Gossamer::Refinements::ObjectToKeysOfHash

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

          update_attributes(options)
          update_material(options)
          update_properties(options)

          # After all that is done, verify that the thing is not abstract.
          if property?(:abstract)
            raise "#{self.class} is abstract and cannot be instantiated"
          end

          # Call constraint checks on the thing before instantiating parts.
          check_constraints

          create_parts(options)
        end

        # Return whether this thing incorporates the requested part, or a part
        # of the requested type (recursive).
        def incorporates?(search_target)
          search_target = thingify(search_target)
          return false if search_target.nil?

          return true if self == search_target || is_a?(search_target)

          parts.any? { |part| part.incorporates?(search_target) }
        end

        # Checks if this thing, its material, or any of its object attributes
        # have the property requested.
        def is?(prop)
          properties.fetch(
            prop,
            material&.properties&.fetch(
              prop,
              attributes.any? do |_, attrib|
                attrib.respond_to?(:properties) &&
                attrib.properties.fetch(prop, false)
              end
            )
          ) || false
        end

        # Override for Object#is_a?, allows for symbol conversion into thing
        # or thing-trait names.
        def is_a?(arg)
          thing = thingify(arg)

          if thing.nil?
            trait = thing_traitify(arg)
            return false if trait.nil?

            self.class <= trait
          else
            super(thing)
          end
        end

        def not?(prop)
          !is?(prop)
        end

        class << self
          # Checks if this thing, its default material, or any of its default
          # object attributes have the property requested.
          def is?(prop)
            properties.fetch(
              prop,
              default_material&.properties&.fetch(
                prop,
                default_attributes.any? do |_, attrib|
                  attrib.respond_to?(:properties) &&
                  attrib.properties.fetch(prop, false)
                end
              )
            ) || false
          end

          def not?(prop)
            !is?(prop)
          end
        end

        private

        def create_parts(options)
          # Get the default part options.
          part_instructions = assembly_instructions.deep_dup

          # Merge in the instructions passed via options, if necessary.
          if options.key?(:parts)
            options[:parts].each do |(part, part_options)|
              part_symbol = dethingify(part)
              part_instructions[part_symbol] ||= {}
              part_instructions[part_symbol].deep_merge!(part_options)
            end
          end

          # Instantiate each part according to the instructions.
          part_instructions.each do |(part_symbol, part_options)|
            part = thingify(part_symbol)

            parts[part_symbol] = part.new(**part_options)
            parts[part_symbol].physical_relation = { part_of: self }
          rescue StandardError => e
            raise "Unable to create the #{part_symbol.inspect} part: " \
                  "#{e.inspect}"
          end
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

        def update_material(options)
          return unless options.key?(:material)

          mat = options[:material]
          if mat.is_a?(Symbol)
            mat = "::Gossamer::World::Materials::#{mat.to_s.camelize}"
                  .safe_constantize
          end

          self.material = mat
        end

        def update_properties(options)
          return unless options.key?(:properties)

          props = options[:properties]

          case props
          when Array
            props = props.to_h { |prop| [prop, true] }
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
