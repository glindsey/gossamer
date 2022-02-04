# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single process.
    class Process < Base
      include Gossamer::Mixins::Log

      def initialize(full_data, path: [])
        super
      end

      def _check
        # Process inheritance first.
        # @todo Maybe also do `is_a_kind_of` here too? Unsure.
        process_inheritance if data.key?('inherits_from')

        check_subkeys do |key, _|
          subpath = path + [key]
          case key
          when 'abstract!'
            ::Gossamer::RuleCops::BooleanData.check(
              full_data, path: subpath
            )
          when 'conditions', 'effects', 'inputs'
            log_nyi(key)
          when 'inherits_from', 'is_a_kind_of'
            # No problem, this was already handled above
          else
            log_unknown(key)
          end
        end
      end
    end
  end
end
