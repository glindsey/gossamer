# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single thing.
    class Thing < Base
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
          when 'always'
            ::Gossamer::RuleCops::Always.check(
              full_data, path: subpath
            )
          when 'has_parts', 'has_properties'
            uhoh("#{key} must be under 'always' or 'usually'")
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'things', path: subpath
            )
          when 'usually'
            ::Gossamer::RuleCops::Usually.check(
              full_data, path: subpath
            )
          else
            unknown(key)
          end
        end
      end
    end
  end
end
