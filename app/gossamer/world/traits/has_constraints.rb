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
          constraints.each do |function|
            result = function&.call(self)
            if result.is_a?(String)
              raise "Object #{inspect} failed creation constraint: #{result}"
            end
          end
        end

        def default_constraints
          @default_constraints ||= []
        end

        def constraints
          defined?(super) ? super : [] |
            default_constraints |
            self.class.mixin_constraints
        end

        class_methods do
          def mixin_constraints
            @mixin_constraints ||= []
          end
        end
      end
    end
  end
end
