# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a single material.
    class Material < Base
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
          when 'has_attributes'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'attributes', path: path + [key]
            ).check
          when 'has_properties'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'properties', path: path + [key]
            ).check
          when 'has_traits'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'traits', path: path + [key]
            ).check
          when 'is_a_kind_of'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'materials', path: path + [key]
            ).check
          when 'processes'
            [note("'processes' is not yet implemented")]
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
