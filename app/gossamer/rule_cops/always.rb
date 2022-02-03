# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for an "always" clause.
    class Always < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_subkeys do |key, value|
          case key
          when 'has_attributes'
            ::Gossamer::RuleCops::AttributeReference.new(
              full_data, path: path + [key]
            ).check
          when 'has_properties'
            ::Gossamer::RuleCops::ConceptReference.new(
              full_data, category: 'properties', path: path + [key]
            ).check
          when 'is_made_of'
            ::Gossamer::RuleCops::ConceptReference.new(
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
