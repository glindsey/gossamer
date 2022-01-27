# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for an integer.
    class IntegerData < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        return [] if data.is_a?(Integer)

        [uhoh("Expected an integer, but got #{data.class}: #{data}")]
      end
    end
  end
end
