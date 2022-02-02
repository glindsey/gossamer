# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for root thing data.
    class RootThings < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Thing)
      end
    end
  end
end
