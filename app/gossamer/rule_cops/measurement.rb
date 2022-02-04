# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single measurement.
    class Measurement < Base
      include Gossamer::Mixins::Log

      def initialize(full_data, path: [])
        super
      end

      def _check
        # Process inheritance first.
        # @todo Maybe also do `is_a_kind_of` here too? Unsure.
        process_inheritance if data.key?('inherits_from')

        verify_exclusive_keys

        check_subkeys do |key, _|
          subpath = path + [key]

          case key
          when 'abstract!'
            ::Gossamer::RuleCops::BooleanData.check(
              full_data, path: subpath
            )
          when 'conversions'
            log_nyi(key)
          when 'format'
            ::Gossamer::RuleCops::UnitFormat.check(
              full_data, path: subpath
            )
          when 'inherits_from', 'is_a_kind_of'
            # No problem, this was already handled above
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
            log_unknown(key)
          end

          verify_min_and_max
        end
      end

      private

      def verify_exclusive_keys
        if data.key?('is_a_kind_of')
          if data.key?('unit')
            check_log("can't have both 'unit' and 'is_a_kind_of' keys",
                      level: :warning)
          end
        else
          unless data.key?('unit')
            check_log("must have either a 'unit' or 'is_a_kind_of' key",
                      level: :warning)
          end
        end
      end

      def verify_min_and_max
        # TODO: Ensure that min < max (if both are present)
        if data.key?('max') &&
           data.key?('min') &&
           data['max'] <= data['min']
          check_log("'max' value #{max} is not larger than 'min' value #{min}",
                    level: :warning)
        end

        # TODO: Ensure that min, max make sense for the type specified
        #       Ensure that min, max are of the same type as "type"
        #         (right now they only check for integers)
      end
    end
  end
end
