# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for traits data.
    class Traits < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Trait)
      end
    end
  end
end
