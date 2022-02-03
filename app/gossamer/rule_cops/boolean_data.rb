# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a boolean.
    class BooleanData < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        return [] if data.is_a?(TrueClass) || data.is_a?(FalseClass)

        uhoh("Expected 'true' or 'false', but got #{data.class}: #{data}")
      end
    end
  end
end
