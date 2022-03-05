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
          local_attrs =
            (defined?(super) ? super : {})
              .merge(local_attributes)

          self.class.attributes.merge(local_attributes)
        end

        def update_attributes(options)
          return unless options.key?(:attributes)

          options[:attributes].each do |(k, v)|
            if v.is_a?(Symbol)
              v = "::Gossamer::World::Attributes::#{v.to_s.camelize}"
                  .safe_constantize
            end

            local_attributes[k] = v
          end
        end

        class_methods do
          def attributes
            (defined?(super) ? super : {}).merge(global_attributes)
          end

          def global_attributes
            @global_attributes ||= {}
          end
        end
      end
    end
  end
end
