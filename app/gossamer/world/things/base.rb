# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Things
      # Definition of a basic "Thing" which all others derive from.
      class Base
        include Concerns::Log
        include Concerns::SmartMerge
        include World::Traits::HasAttributes
        include World::Traits::HasConstraints
        include World::Traits::HasMaterial
        include World::Traits::HasParts
        include World::Traits::HasProperties
        include World::Traits::HasTags
        include Things::Traits::PhysicallyRelatable
        using ::Gossamer::Refinements::ObjectToKeysOfHash

        attr_reader :id, :pool

        # Instantiation of a Thing can only be done if it is not abstract.
        def initialize(uuid, pool:, **options)
          log("Creating #{self.class.name}, uuid #{uuid.inspect}, " \
              "pool = #{pool.inspect}, options = #{options.inspect}")

          @id = uuid
          @pool = pool

          # Call any mixin option lambdas and merge them into options.
          options = self.class.merge_with_default_config(options)

          create_attributes_from(options)
          create_material_from(options)
          create_properties_from(options)
          create_tags_from(options)

          # After all that is done, verify that the thing is not abstract.
          if property?(:abstract)
            raise "#{self.class} is abstract and cannot be instantiated"
          end

          # Call constraint checks on the thing before instantiating parts.
          check_constraints

          create_parts(options)
        end

        # Checks if this thing, its material, or any of its object attributes
        # have the property requested.
        def is?(prop)
          return property?(prop) if property_exists?(prop)

          return material.property?(prop) if material&.property_exists?(prop)

          attributes.any? do |_, attrib|
            attrib.property_exists?(prop) && attrib.property?(prop)
          end
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
            meth_sym = "#{prop}?".to_sym

            return send(meth_sym) if respond_to?(meth_sym)

            if default_material.respond_to?(meth_sym)
              return default_material.send(meth_sym)
            end

            global_attributes.each do |_, attrib|
              return attrib.send(meth_sym) if attrib.respond_to?(:meth_sym)
            end

            false
          end

          def not?(prop)
            !is?(prop)
          end

          def merge_with_default_config(opts)
            # Look at this functional programming nightmare. LOOK at it.
            mixin_config_funcs_after.inject(
              smart_merge(
                mixin_config_funcs_before.inject(
                  defined?(super) ? super : recursive_default_config
                ) { |memo, func| func.call(memo) },
                opts || {}
              )
            ) { |memo, func| func.call(memo) }
          end

          def recursive_default_config
            if defined?(super)
              smart_merge(super, default_config)
            else
              default_config
            end
          end

          def default_config
            {}
          end

          def mixin_config_funcs_before
            @mixin_config_funcs_before ||= []
          end

          def mixin_config_funcs_after
            @mixin_config_funcs_after ||= []
          end
        end

        private

        def finalize_part_instructions(part_instr, options)
          part_instr ||= {}

          return part_instr unless options.key?(:parts)

          # Merge in the instructions passed via options, if necessary.
          options[:parts].each_with_object(part_instr) do |(part, opts), instr|
            part_symbol = degossamerify(part)
            instr[part_symbol] ||= {}

            # Merge in incorporator's tags, if any.
            if options.key?(:tags)
              instr[part_symbol][:tags] ||= []
              instr[part_symbol][:tags] =
                instr[part_symbol][:tags] | options[:tags]
            end

            instr[part_symbol] = smart_merge(instr[part_symbol], opts)
          end
        end

        def create_parts(options)
          # Get the part options.
          part_instructions =
            finalize_part_instructions(part_instructions, options)

          # Instantiate each part according to the instructions.
          part_instructions.each do |(part_symbol, part_options)|
            part = thingify(
              if part_options.key?(:type)
                part_options[:type]
              else
                part_symbol
              end
            )

            log("*** #{part_symbol.inspect}: Creating part #{part.inspect} " \
                "with options #{part_options.inspect}")

            new_part = pool.create(part, **part_options)
            new_part.physical_relation = { part_of: id }
            part_ids[part_symbol] = new_part.id
          rescue StandardError => e
            raise "Unable to create the #{part_symbol.inspect} part: " \
                  "#{e.inspect}"
          end
        end

        def create_material_from(options)
          return unless options.key?(:material)

          mat = options[:material]
          if mat.is_a?(Symbol)
            mat = "::Gossamer::World::Materials::#{mat.to_s.camelize}"
                  .safe_constantize
          end

          self.material = mat
        end
      end
    end
  end
end
