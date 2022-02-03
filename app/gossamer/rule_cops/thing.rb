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
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'things', path: subpath
            )
          when 'usually'
            ::Gossamer::RuleCops::Usually.check(
              full_data, path: subpath
            )
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
