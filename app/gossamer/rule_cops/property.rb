# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single property.
    class Property < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
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
          when 'senses'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'senses', path: subpath
            )
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end

        # @todo Check that 'is_a_kind_of' entries are not in 'excludes'
      end
    end
  end
end
