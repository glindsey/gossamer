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

        def local_constraints
          @local_constraints ||= []
        end

        def constraints
          (self.class.default_constraints | local_constraints).freeze
        end

        class_methods do
          def default_constraints
            @default_constraints ||= []
          end
        end
      end
    end
  end
end
