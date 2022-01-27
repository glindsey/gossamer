# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for sensory input types.
    class Senses < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Sense)
      end
    end
  end
end
