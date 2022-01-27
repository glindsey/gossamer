# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for processes data.
    class Processes < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Process)
      end
    end
  end
end
