# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that the instantiated objects of a class have attributes that
      # can be read/written/queried. Attributes can be a number of things, but
      # if they are symbols, they are automatically converted into references to
      # the corresponding `World::Attributes` class.
      #
      # Eventually this may be extended to support class-level attributes, but
      # for now I don't think that's necessary.
      module HasAttributes
        extend ActiveSupport::Concern
        include Concerns::SymbolToGossamerClass
        using Refinements::ObjectToKeysOfHash

        def attributes
          _attributes.freeze
        end

        def attribute_keys
          _attributes.keys
        end

        def attribute_set(key, value)
          _attributes[key] = attributify(key, value)
        end

        def attribute_reset(key)
          _attributes.erase(key)
        end

        def attribute?(attrib)
          _attributes.key?(attrib) || self.class.respond_to?(attrib)
        end

        def attribute(attrib)
          return _attributes[attrib] if _attributes.key?(attrib)

          return self.class.send(attrib) if self.class.respond_to?(attrib)

          nil
        end

        def create_attributes_from(options)
          return unless options.key?(:attributes)

          options[:attributes].each do |(k, v)|
            attribute_set(k, v)
          end
        end

        private

        def _attributes
          @_attributes ||= {}
        end
      end
    end
  end
end
