# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that the instantiated objects of a class have subparts that
      # are also instantiated at the time of creation.
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
      module HasParts
        extend ActiveSupport::Concern
        include Concerns::SymbolToGossamerClass
        using Refinements::ObjectToKeysOfHash

        def parts
          @parts ||= {}
        end

        # Return whether this thing incorporates all the requested parts.
        def parts?(*search_targets)
          search_targets.all? { |target| part?(target) }
        end

        # Return the requested part. If the part does not exist, return nil.
        # (Functionally similar to `parts[]` or `parts.fetch()`, except that one
        # can pass in a class instead of a symbol.)
        def part(search_target)
          parts.fetch(degossamerify(search_target), nil)
        end

        # Return whether this thing incorporates the requested part, or a part
        # of the requested type. (Non-recursive.)
        def part?(search_target)
          case search_target
          when Symbol, String, Class
            parts.key?(degossamerify(search_target))
          else
            parts.value?(search_target)
          end
        end

        # Return whether this thing incorporates the requested part, or a part
        # of the requested type (recursive).
        def incorporates?(*search_targets)
          search_targets.all? do |search_target|
            case search_target
            when String, Symbol
              parts.key?(search_target) ||
                parts.values.any? { |part| part.incorporates?(search_target) }
            else
              search_target = thingify(search_target)
              return false if search_target.nil?

              return true if self == search_target || is_a?(search_target)

              parts.values.any? { |part| part.incorporates?(search_target) }
            end
          end
        end
      end
    end
  end
end
