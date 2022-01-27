# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for measurement unit data.
    class Units < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        if data.is_a?(Hash)
          data.each do |(unit, _)|
            log += ::Gossamer::SanityCheckers::Unit.new(
              full_data, path: path + [unit]
            ).check
          end
        else
          log.push(
            uhoh("Expected a hash but got a #{data.class}")
          )
        end

        log
      end
    end
  end
end
