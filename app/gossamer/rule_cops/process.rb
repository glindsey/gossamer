# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single process.
    class Process < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        # Process inheritance first.
        # @todo Maybe also do `is_a_kind_of` here too? Unsure.
        process_inheritance if data.key?('inherits_from')

        check_subkeys do |key, _|
          subpath = path + [key]
          case key
          when 'abstract!'
            ::Gossamer::RuleCops::BooleanData.check(
              full_data, path: subpath
            )
          when 'conditions', 'effects', 'inputs'
            nyi(key)
          when 'inherits_from'
            # No problem, this was already handled above
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'processes', path: subpath
            )
          else
            unknown(key)
          end
        end
      end
    end
  end
end
