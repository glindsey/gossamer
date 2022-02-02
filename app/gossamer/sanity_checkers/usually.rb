# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a "usually" clause.
    class Usually < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_subkeys do |key, value|
          case key
          when 'has_attributes'
            ::Gossamer::SanityCheckers::AttributeReference.new(
              full_data, path: path + [key]
            ).check
          when 'has_properties'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'properties', path: path + [key]
            ).check
          when 'is_made_of'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'materials', path: path + [key]
            ).check
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end
      end
    end
  end
end
