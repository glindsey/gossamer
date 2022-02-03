# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single sense.
    class Sense < Base
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
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'senses', path: subpath
            )
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
