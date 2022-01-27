# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a single unit.
    class Unit < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        log += [uhoh("'measures' key is missing")] unless data.key?('measures')

        log += check_subkeys do |key, value|
          case key
          when 'abstract!'
            unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
              [uhoh("#{value} isn't a boolean value")]
            end
          when 'convert_to'
            [note("'convert_to' is not yet implemented")]
          when 'format'
            ::Gossamer::SanityCheckers::UnitFormat.new(
              full_data, path: path + [key]
            ).check
          when 'is_a_kind_of'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'units', path: path + [key]
            ).check
          when 'max', 'min'
            ::Gossamer::SanityCheckers::IntegerData.new(
              full_data, path: path + [key]
            ).check
          when 'measures'
            ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'measurements', path: path + [key]
            ).check
          when 'type'
            ::Gossamer::SanityCheckers::BuiltinType.new(
              full_data, path: path + [key]
            ).check
          else
            [uhoh("don't know how to interpret #{key}")]
          end
        end

        # TODO: Ensure that min < max (if both are present)
        #       Ensure that min, max make sense for the type specified
        #       Ensure that min, max are of the same type as "type" (right now
        #         they only check for integers)
        log
      end
    end
  end
end
