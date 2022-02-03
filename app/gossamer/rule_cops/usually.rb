# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a "usually" clause.
    class Usually < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_subkeys do |key, _|
          subpath = path + [key]
          case key
          when 'has_attributes'
            ::Gossamer::RuleCops::AttributeReference.check(
              full_data, path: subpath
            )
          when 'has_parts'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'things', path: subpath
            )
          when 'has_properties'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'properties', path: subpath
            )
          when 'is_made_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'materials', path: subpath
            )
          else
            unknown(key)
          end
        end
      end
    end
  end
end
