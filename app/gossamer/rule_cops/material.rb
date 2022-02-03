# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single material.
    class Material < Base
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
          when 'has_attributes'
            ::Gossamer::RuleCops::AttributeReference.check(
              full_data, path: subpath
            )
          when 'has_refs'
            [note("'has_refs' is not yet implemented")]
          when 'implies'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'properties', path: subpath
            )
          when 'is_a_kind_of'
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
