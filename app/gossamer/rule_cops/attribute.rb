# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single attribute.
    class Attribute < Base
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
          when 'implies'
            ::Gossamer::RuleCops::ConceptReference.new(
              full_data, category: 'properties', path: path + [key]
            ).check
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.new(
              full_data, category: 'attributes', path: path + [key]
            ).check
          when 'measurement'
            ::Gossamer::RuleCops::ConceptReference.new(
              full_data, category: 'measurements', path: path + [key]
            ).check
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
