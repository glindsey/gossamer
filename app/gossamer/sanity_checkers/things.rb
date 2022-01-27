# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for thing data.
    class Things < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        if data.is_a?(Hash)
          data.each do |(thing, _)|
            log += ::Gossamer::SanityCheckers::Thing.new(
              full_data, path: path + [thing]
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
