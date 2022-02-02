# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for root measurements data.
    class RootMeasurements < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Measurement)
      end
    end
  end
end
