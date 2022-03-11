# frozen_string_literal: true

require 'pry'
require 'pry-byebug'
require 'pry-stack_explorer'
require 'sourcify'

require COMMON_REQUIRES

module Gossamer
  module Concerns
    # Mixin to add assertions when running in a non-production environment.
    #
    # @todo Turn off assertions when in a non-production environment. Right now
    #       there's no way to distinguish "development" mode from "production".
    #
    module Assertions
      extend ActiveSupport::Concern

      # Raise an error if the passed-in block is not truthy.
      def assert(&)
        result = yield

        return if result

        str = <<~TEXT
          Assertion failed:
            #{block_to_source(&)}
        TEXT

        if ::Gossamer.development?
          warn "*** #{str}"
          binding.pry # rubocop:disable Lint/Debugger
        elsif ::Gossamer.test?
          raise str
        end
      end

      def block_to_source(&block)
        block.to_source(strip_enclosure: true)
      end
    end
  end
end
