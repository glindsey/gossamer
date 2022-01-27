# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for materials data.
    class Materials < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Material)
      end
    end
  end
end
