# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for an "always" clause.
    class Always < Base
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
          when 'has_properties'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'properties', path: subpath
            )
          when 'is_made_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'materials', path: subpath
            )
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
