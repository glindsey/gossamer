# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single property.
    class Property < Base
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
          when 'excludes', 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'properties', path: subpath
            )
          when 'inherits_from'
            # No problem, this was already handled above
          when 'senses'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'senses', path: subpath
            )
          else
            unknown(key)
          end
        end

        # @todo Check that 'is_a_kind_of' entries are not in 'excludes'
      end
    end
  end
end
