# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a string.
    class StringData < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        expect(String)
      end
    end
  end
end
