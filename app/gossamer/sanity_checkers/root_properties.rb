# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for root properties data.
    class RootProperties < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Property)
      end
    end
  end
end