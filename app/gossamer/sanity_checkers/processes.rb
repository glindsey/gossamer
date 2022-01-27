# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for processes data.
    class Processes < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        if data.is_a?(Hash)
          data.each do |(process, _)|
            log += ::Gossamer::SanityCheckers::Process.new(
              full_data, path: path + [process]
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
