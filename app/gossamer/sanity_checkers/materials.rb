# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for materials data.
    class Materials < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        if data.is_a?(Hash)
          data.each do |(material, _)|
            log += ::Gossamer::SanityCheckers::Material.new(
              full_data, path: path + [material]
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
