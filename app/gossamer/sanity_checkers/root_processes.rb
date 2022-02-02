# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for root processes data.
    class RootProcesses < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Process)
      end
    end
  end
end
