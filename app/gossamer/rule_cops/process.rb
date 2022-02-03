# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single process.
    class Process < Base
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
          when 'conditions'
            [note("'conditions' is not yet implemented")]
          when 'effects'
            [note("'effects' is not yet implemented")]
          when 'inputs'
            [note("'inputs' is not yet implemented")]
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'processes', path: subpath
            )
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
