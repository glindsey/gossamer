# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for attributes data.
    class Attributes < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Attribute)
      end
    end
  end
end
