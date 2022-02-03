# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a boolean.
    class BooleanData < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        expect_one_of([TrueClass, FalseClass])
      end
    end
  end
end
