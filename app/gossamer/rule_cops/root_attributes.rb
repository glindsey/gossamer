# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for root attributes data.
    class RootAttributes < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::RuleCops::Attribute)
      end
    end
  end
end
