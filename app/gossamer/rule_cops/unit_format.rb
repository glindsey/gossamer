# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a unit format.
    class UnitFormat < Base
      include Gossamer::Mixins::Log

      def initialize(full_data, path: [])
        super
      end

      def _check
        unless data.is_a?(Hash)
          unless data.key?('full') || data.key?('abbreviated')
            check_log(
              "Format must have at least one of 'full' or 'abbreviated' forms",
              level: :warning
            )
          end

          %w[full abbreviated].filter_map do |str|
            ::Gossamer::RuleCops::FormatString.check(
              full_data, path: path + [str]
            )
          end
        end || []
      end
    end
  end
end
