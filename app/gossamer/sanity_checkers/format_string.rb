# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a formatting string.
    class FormatString < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        return [] if data.is_a?(String)

        [uhoh("Expected a string, but got #{data}")]
      end
    end
  end
end
