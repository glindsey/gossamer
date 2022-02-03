# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for root properties data.
    class RootProperties < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::RuleCops::Property)
      end
    end
  end
end
