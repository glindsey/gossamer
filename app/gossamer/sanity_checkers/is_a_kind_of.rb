# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for the "is_a_kind_of" rule.
    class IsAKindOf < Base
      def initialize(full_data, category:, path: [])
        super(full_data, path: path)

        @category = category
      end

      def category_data
        full_data[@category]
      end

      def _check
        log = []

        case data
        when String
          unless category_data.key?(data)
            log.push(
              uhoh("Defined as a kind of '#{data}', but that is not defined")
            )
          end
        when Array
          data.each do |subval|
            next if category_data.key?(subval)

            log.push(
              uhoh("Defined as a kind of '#{subval}', but that is not defined")
            )
          end
        else
          log.push(
            uhoh("'is_a_kind_of' expects a string or array, not #{data}")
          )
        end

        log
      end
    end
  end
end
