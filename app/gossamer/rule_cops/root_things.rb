# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for root thing data.
    class RootThings < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::RuleCops::Thing)
      end
    end
  end
end
