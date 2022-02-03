# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single measurement.
    class Measurement < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = verify_exclusive_keys

        log += check_subkeys do |key, _|
          subpath = path + [key]
          log =
            case key
            when 'abstract!'
              ::Gossamer::RuleCops::BooleanData.check(
                full_data, path: subpath
              )
            when 'conversions'
              nyi(key)
            when 'format'
              ::Gossamer::RuleCops::UnitFormat.check(
                full_data, path: subpath
              )
            when 'is_a_kind_of'
              ::Gossamer::RuleCops::ConceptReference.check(
                full_data, category: 'measurements', path: subpath
              )
            when 'max', 'min'
              ::Gossamer::RuleCops::IntegerData.check(
                full_data, path: subpath
              )
            when 'type'
              ::Gossamer::RuleCops::BuiltinType.check(
                full_data, path: subpath
              )
            when 'unit'
              ::Gossamer::RuleCops::StringData.check(
                full_data, path: subpath
              )
            else
              unknown(key)
            end

          assert { !log.nil? }

          log + verify_min_and_max
        end

        log
      end

      private

      def verify_exclusive_keys
        log = []

        if data.key?('is_a_kind_of')
          if data.key?('unit')
            log += uhoh("can't have both 'unit' and 'is_a_kind_of' keys")
          end
        else
          unless data.key?('unit')
            log += uhoh("must have either a 'unit' or 'is_a_kind_of' key")
          end
        end

        log
      end

      def verify_min_and_max
        log = []

        # TODO: Ensure that min < max (if both are present)
        if data.key?('max') && data.key?('min') &&
           data['max'] <= data['min']
          log += uhoh("'max' value #{max} is not larger than " \
                      "'min' value #{min}")
        end

        # TODO: Ensure that min, max make sense for the type specified
        #       Ensure that min, max are of the same type as "type"
        #         (right now they only check for integers)

        log
      end
    end
  end
end
