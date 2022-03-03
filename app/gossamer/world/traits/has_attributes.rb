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
        using ::Gossamer::Refinements::ObjectToKeysOfHash

        def local_attributes
          @local_attributes ||= {}
        end

        def attribute(attr)
          attributes.key?(attr) ? attributes[attr] : nil
        end

        def attribute?(attr)
          attributes.key?(attr)
        end

        def attributes
          self.class.default_attributes.merge(local_attributes).freeze
        end

        class_methods do
          def default_attributes
            @default_attributes ||= {}
          end
        end
      end
    end
  end
end
