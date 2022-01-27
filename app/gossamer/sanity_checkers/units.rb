# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for measurement unit data.
    class Units < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Unit)
      end
    end
  end
end
