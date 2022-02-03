# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a single measurement.
    class Measurement < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = verify_exclusive_keys

        check_subkeys do |key, value|
          case key
          when 'abstract!'
            unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
              log += [uhoh("#{value} isn't a boolean value")]
            end
          when 'conversions'
            log += [note("'conversions' is not yet implemented")]
          when 'format'
            log += ::Gossamer::SanityCheckers::UnitFormat.new(
              full_data, path: path + [key]
            ).check
          when 'is_a_kind_of'
            log += ::Gossamer::SanityCheckers::ConceptReference.new(
              full_data, category: 'measurements', path: path + [key]
            ).check
          when 'max', 'min'
            log += ::Gossamer::SanityCheckers::IntegerData.new(
              full_data, path: path + [key]
            ).check
          when 'type'
            log += ::Gossamer::SanityCheckers::BuiltinType.new(
              full_data, path: path + [key]
            ).check
          when 'unit'
            log += ::Gossamer::SanityCheckers::StringData.new(
              full_data, path: path + [key]
            ).check
          else
            log += [uhoh("don't know how to interpret #{key}")]
          end

          log += verify_min_and_max
        end

        log
      end

      private

      def verify_exclusive_keys
        log = []

        if data.key?('is_a_kind_of')
          if data.key?('unit')
            log += [uhoh("can't have both 'unit' and 'is_a_kind_of' keys")]
          end
        else
          unless data.key?('unit')
            log += [uhoh("must have either a 'unit' or 'is_a_kind_of' key")]
          end
        end

        log
      end

      def verify_min_and_max
        log = []

        # TODO: Ensure that min < max (if both are present)
        if data.key?('max') && data.key?('min') &&
           data['max'] <= data['min']
          log += [uhoh("'max' value #{max} is not larger than " \
                       "'min' value #{min}")]
        end

        # TODO: Ensure that min, max make sense for the type specified
        #       Ensure that min, max are of the same type as "type"
        #         (right now they only check for integers)

        log
      end
    end
  end
end
