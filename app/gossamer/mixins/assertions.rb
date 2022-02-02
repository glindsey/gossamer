# frozen_string_literal: true

module Gossamer
  module Mixins
    # Mixin to add assertions when running in a non-production environment.
    #
    # @todo Turn off assertions when in a non-production environment. Right now
    #       there's no way to distinguish "development" mode from "production".
    module Assertions
      # Raise an error if the passed-in block is not truthy.
      def assert(&block)
        result = yield

        return if result

        raise "Assertion failed: #{block_to_source(&block)}"
      end

      def block_to_source(&block)
        block.to_source(strip_enclosure: true)
      end
    end
  end
end
