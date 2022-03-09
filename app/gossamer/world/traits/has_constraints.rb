# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that a class has constraints that are checked when an object
      # is created.
      module HasConstraints
        extend ActiveSupport::Concern
        using ::Gossamer::Refinements::ObjectToKeysOfHash

        def check_constraints
          self.class.constraints.each do |function|
            result = function&.call(self)
            if result.is_a?(String)
              raise "Object #{inspect} failed creation constraint: #{result}"
            end
          end
        end

        class_methods do
          attr_writer :mixin_constraints

          def constraints
            if defined?(super)
              super
            else
              [] | class_constraints | mixin_constraints
            end
          end

          def class_constraints
            []
          end

          def mixin_constraints
            @mixin_constraints ||= []
          end
        end
      end
    end
  end
end
