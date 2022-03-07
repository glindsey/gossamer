# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that a class and its instantiated objects have attributes that
      # can be read/written/queried. Attributes can be a number of things, but
      # if they are symbols, they are automatically converted into references to
      # the corresponding `World::Attributes` class.
      module HasAttributes
        extend ActiveSupport::Concern
        include Concerns::SymbolToGossamerClass
        using Refinements::ObjectToKeysOfHash

        def attributes
          @attributes ||= {}
        end

        def attribute?(attrib)
          attributes.key?(attrib) || self.class.respond_to?(attrib)
        end

        def attribute(attrib)
          return attributes[attrib] if attributes.key?(attrib)

          return self.class.send(attrib) if self.class.respond_to?(attrib)

          nil
        end

        def create_attributes_from(options)
          return unless options.key?(:attributes)

          options[:attributes].each { |(k, v)| attributes[k] = attributify(v) }
        end
      end
    end
  end
end
