# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for measurements data.
    class Measurements < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Measurement)
      end
    end
  end
end
