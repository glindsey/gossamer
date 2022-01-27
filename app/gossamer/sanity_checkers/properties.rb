# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for properties data.
    class Properties < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        if data.is_a?(Hash)
          data.each do |(property, _)|
            log += ::Gossamer::SanityCheckers::Property.new(
              full_data, path: path + [property]
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
