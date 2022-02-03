# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for an integer.
    class IntegerData < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        expect(Integer)
      end
    end
  end
end
