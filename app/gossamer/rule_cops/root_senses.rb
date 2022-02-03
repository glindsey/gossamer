# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for root sensory input types.
    class RootSenses < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::RuleCops::Sense)
      end
    end
  end
end
