# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that the instantiated objects of a class have subparts that
      # are also instantiated at the time of creation.
      #
      # Parts work somewhat differently than attributes/properties/etc. because
      # they are instantiated at the time of creation. As a result, the
      # `default_parts` class instance variable is a map of symbols to options
      # to use upon instantiation, but the `parts` instance variable is a map of
      # symbols to actual instances of the classes.
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
          parts.fetch(dethingify(search_target), nil)
        end

        # Return whether this thing incorporates the requested part, or a part
        # of the requested type. (Non-recursive.)
        def part?(search_target)
          case search_target
          when Symbol, String, Class
            parts.key?(dethingify(search_target))
          else
            parts.value?(search_target)
          end
        end

        class_methods do
          def mixin_parts
            @mixin_parts ||= {}
          end

          def default_parts
            class_default_parts.deep_merge(mixin_parts)
          end

          def class_default_parts
            {}
          end
        end
      end
    end
  end
end
