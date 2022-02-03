# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for root processes data.
    class RootProcesses < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::RuleCops::Process)
      end
    end
  end
end
