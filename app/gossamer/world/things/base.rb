# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module World
    module Things
      # Definition of a basic "Thing" which all others derive from.
      # A "Thing" has attributes, constraints, a material, parts, properties,
      # and tags. Many of these are implemented via their own mixins; material
      # parts, and tags are specific to Things, though, so they are implemented
      # right here.
      #
      # PARTS:
      #
      # Parts work somewhat differently than attributes/properties/etc. because
      # they are instantiated at the time of creation. As a result, the `parts`
      # map contained within instantiation options is a map of symbols to
      # options to use upon instantiation, but the `parts` instance variable is
      # a map of symbols to actual instances of the classes.
      #
      # By default, the part that is instantiated is defined by the symbol that
      # names it; for example, `head: {}` will create a part of type
      # `World::Things::Head`. However, in some cases we want multiple instances
      # of the same part, such as a left leg and a right leg. In those cases, we
      # can use the option `type:` to specify the part to create.
      #
      # TAGS:
      #
      # Unlike attributes or properties, tags are *inherited* by subparts of
      # a thing. For example, if a "left leg" has a "foot" subpart, it will be
      # a "left foot" when created.
      #
      # Eventually tags may be extended to support class-level tags, but for now
      # I don't think that's necessary.
      class Base
        include Concerns::Log
        include Concerns::SmartMerge
        include Concerns::SymbolToGossamerClass
        include World::Traits::HasAttributes
        include World::Traits::HasConstraints
        include World::Traits::HasProperties
        include Things::Traits::PhysicallyRelatable
        using ::Gossamer::Refinements::ObjectToKeysOfHash

        attr_reader :id, :pool

        #                      _              _
        #   ___ ___  _ __  ___| |_ __ _ _ __ | |_ ___
        #  / __/ _ \| '_ \/ __| __/ _` | '_ \| __/ __|
        # | (_| (_) | | | \__ \ || (_| | | | | |_\__ \
        #  \___\___/|_| |_|___/\__\__,_|_| |_|\__|___/

        BILATERAL_PAIR = %i[left right].freeze

        #              _     _ _
        #  _ __  _   _| |__ | (_) ___
        # | '_ \| | | | '_ \| | |/ __|
        # | |_) | |_| | |_) | | | (__
        # | .__/ \__,_|_.__/|_|_|\___|
        # |_|

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

        def attributes
          smart_merge((material&.attributes || {}), _attributes).freeze
        end

        def attribute_keys
          (material&.attribute_keys || []) | _attributes.keys
        end

        def attribute_set(key, value)
          if material&.attribute?(key)
            material&.attribute_set(key, value)
          else
            _attributes[key] = attributify(key, value)
          end
        end

        def attribute_reset(key)
          if material&.attribute?(key)
            material&.attribute_reset(key)
          else
            _attributes.erase(key)
          end
        end

        # Checks if this thing or its material have the attribute requested.
        def attribute?(attrib)
          material&.attribute?(attrib) ||
            _attributes.key?(attrib) ||
            self.class.respond_to?(attrib)
        end

        # Checks the thing or its material for the attribute requested, and
        # returns the value.
        def attribute(attrib)
          return material&.attribute(attrib) if material&.attribute?(attrib)

          return _attributes[attrib] if _attributes.key?(attrib)

          return self.class.send(attrib) if self.class.respond_to?(attrib)

          nil
        end

        # Return whether this thing incorporates the requested part, or a part
        # of the requested type. Optionally, search criteria can be passed in as
        # a list of required tags and/or a block which can be checked against.
        def incorporates?(*search_targets, required_tags: [], &block)
          search_targets.all? do |target|
            incorporates_one?(target, required_tags:, &block)
          end
        end

        # Same as `incorporates?`, but for a single target. Used to cut down on
        # method complexity.
        def incorporates_one?(search_target, required_tags: [], &block)
          case search_target
          when String, Symbol
            part?(search_target, required_tags:, &block) ||
              parts.values.any? do |part|
                part.incorporates?(
                  search_target, required_tags:, &block
                )
              end
          else
            incorporates_str_or_sym?(search_target, required_tags:, &block)
          end
        end

        # Return whether this thing incorporates a left/right pair of the
        # requested part, or a part of the requested type. Optionally, search
        # criteria can be passed in as a list of required tags and/or a block
        # which can be checked against.
        def incorporates_a_pair_of?(*search_targets, required_tags: [], &block)
          search_targets.all? do |search_pair|
            search_target = search_pair.to_s.singularize.to_sym
            case search_pair
            when String, Symbol
              search_pair.to_s.singularize.to_sym
            else
              thingify(search_target)
            end

            if search_target.nil?
              false
            else
              BILATERAL_PAIR.all? do |adj|
                incorporates?(
                  search_target,
                  required_tags: required_tags | [adj],
                  &block
                )
              end
            end
          end
        end

        # Checks if this thing, its material, or any of its object attributes
        # have the property requested.
        def is?(prop)
          return property?(prop) if property_exists?(prop)

          return material.property?(prop) if material&.property_exists?(prop)

          attributes.any? do |_, attrib|
            return attrib.property?(prop) if attrib.property_exists?(prop)
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

        def material=(mat)
          @material = materialify(mat)&.new
        end

        def material?
          !material.nil?
        end

        def not?(prop)
          !is?(prop)
        end

        # Return the part matching the requested symbol, class, or object.
        # If the part does not exist, return nil.
        #
        # (Functionally similar to `parts[]` or `parts.fetch()`, except that one
        # can pass in a class instead of a symbol.)
        def part(search_target)
          case search_target
          when Symbol, String, Class
            parts.fetch(degossamerify(search_target), nil)
          else
            parts.values.any?(search_target)
          end
        end

        # Return whether this thing incorporates the requested part, or a part
        # of the requested type. Optionally, search criteria can be passed in
        # as a list of required tags and/or a block which can be checked
        # against. (Non-recursive.)
        def part?(search_target, required_tags: [], &block)
          matching_parts = [part(search_target)].compact

          case search_target
          when Symbol, String, Class
            if matching_parts.blank?
              search_sym = degossamerify(search_target)
              matching_parts = parts.values.select do |checked_part|
                part_sym = degossamerify(checked_part)
                search_sym == part_sym && checked_part.tags?(required_tags)
              end
            end
          end

          return matching_parts.present? if matching_parts.blank? || !block

          matching_parts.any?(&block)
        end

        def parts
          part_ids.transform_values { |uuid| pool[uuid] }.freeze
        end

        # Return whether this thing incorporates all the requested parts.
        def parts?(*search_targets)
          search_targets.all? { |target| part?(target) }
        end

        def tag?(tag)
          tags.include?(tag)
        end

        def tags?(checked_tags)
          checked_tags.all? { |tag| tag?(tag) }
        end

        #                                 _             _
        #  _ __ ___   ___ _ __ ___   ___ (_)_______  __| |
        # | '_ ` _ \ / _ \ '_ ` _ \ / _ \| |_  / _ \/ _` |
        # | | | | | |  __/ | | | | | (_) | |/ /  __/ (_| |
        # |_| |_| |_|\___|_| |_| |_|\___/|_/___\___|\__,_|

        def material
          @material ||= self.class.default_material&.new
        end

        def part_ids
          @part_ids ||= {}
        end

        def tags
          @tags ||= Set.new
        end

        #              _     _ _             _
        #  _ __  _   _| |__ | (_) ___    ___| | __ _ ___ ___
        # | '_ \| | | | '_ \| | |/ __|  / __| |/ _` / __/ __|
        # | |_) | |_| | |_) | | | (__  | (__| | (_| \__ \__ \
        # | .__/ \__,_|_.__/|_|_|\___|  \___|_|\__,_|___/___/
        # |_|

        class << self
          def default_config
            {}
          end

          def default_material
            nil
          end

          def default_material?
            !default_material.nil?
          end

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

          def mixin_config_funcs_before
            @mixin_config_funcs_before ||= []
          end

          def mixin_config_funcs_after
            @mixin_config_funcs_after ||= []
          end

          def not?(prop)
            !is?(prop)
          end

          def recursive_default_config
            if defined?(super)
              smart_merge(super, default_config)
            else
              default_config
            end
          end
        end

        #             _            _
        #  _ __  _ __(_)_   ____ _| |_ ___
        # | '_ \| '__| \ \ / / _` | __/ _ \
        # | |_) | |  | |\ V / (_| | ||  __/
        # | .__/|_|  |_| \_/ \__,_|\__\___|
        # |_|

        private

        def create_material_from(options)
          return unless options.key?(:material)

          mat = options[:material]
          if mat.is_a?(Symbol)
            mat = "::Gossamer::World::Materials::#{mat.to_s.camelize}"
                  .safe_constantize
          end

          self.material = mat
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

        def create_tags_from(options)
          return unless options.key?(:tags)

          unless options[:tags].is_a?(Array)
            raise 'options[:tags] must be an Array'
          end

          tags.merge(options[:tags])
        end

        def finalize_part_instructions(part_instr, options)
          part_instr ||= {}

          return part_instr unless options.key?(:parts)

          # Merge in the instructions passed via options, if necessary.
          options[:parts].each_with_object(part_instr) do |(part, opts), instr|
            part_symbol = degossamerify(part)
            instr[part_symbol] ||= {}

            # Merge in our own tags, if any.
            instr[part_symbol][:tags] ||= []
            instr[part_symbol][:tags] |= tags.to_a

            # Merge in option tags, if any.
            if options.key?(:tags)
              instr[part_symbol][:tags] =
                instr[part_symbol][:tags] | options[:tags]
            end

            instr[part_symbol] = smart_merge(instr[part_symbol], opts)
          end
        end

        def incorporates_str_or_sym?(search_target, required_tags: [], &block)
          search_target = thingify(search_target)
          if search_target.nil?
            false
          elsif self == search_target || is_a?(search_target)
            tags?(required_tags) && block ? yield(self) : true
          else
            parts.values.any? do |part|
              part.incorporates?(
                search_target, required_tags:, &block
              )
            end
          end
        end
      end
    end
  end
end
