# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single attribute.
    class Attribute < Base
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
          when 'implies'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'properties', path: subpath
            )
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'attributes', path: subpath
            )
          when 'measurement'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'measurements', path: subpath
            )
          else
            unknown(key)
          end
        end
      end
    end
  end
end
