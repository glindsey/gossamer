# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a unit format.
    class UnitFormat < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        unless data.is_a?(Hash)
          return uhoh("Expected a string, but got #{data}")
        end

        unless data.key?('full') || data.key?('abbreviated')
          return uhoh(
            "Format must have at least one of 'full' or 'abbreviated' forms"
          )
        end

        %w[full abbreviated].filter_map do |str|
          ::Gossamer::RuleCops::FormatString.check(
            full_data, path: path + [str]
          )
        end || []
      end
    end
  end
end
