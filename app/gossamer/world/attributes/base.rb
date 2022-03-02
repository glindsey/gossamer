# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module World
    module Attributes
      # Base class for attributes.
      class Base
        def is?(prop)
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
          # An Attribute is abstract by default, and cannot be instantiated.
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
      end
    end
  end
end
