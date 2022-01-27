# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for properties data.
    class Properties < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Property)
      end
    end
  end
end
