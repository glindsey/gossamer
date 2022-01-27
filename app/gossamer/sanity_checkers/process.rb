# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a single process.
    class Process < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_subkeys do |key, value|
          case key
          when 'abstract!'
            unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
              [uhoh("#{value} isn't a boolean value")]
            end
          when 'conditions'
            [note("'conditions' is not yet implemented")]
          when 'effects'
            [note("'effects' is not yet implemented")]
          when 'inputs'
            [note("'inputs' is not yet implemented")]
          when 'is_a_kind_of'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'processes', path: path + [key]
            ).check
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
