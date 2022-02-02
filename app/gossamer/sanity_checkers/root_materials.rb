# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for root materials data.
    class RootMaterials < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_root_group(::Gossamer::SanityCheckers::Material)
      end
    end
  end
end
