# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a built-in type.
    class BuiltinType < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        if data.is_a?(String)
          [
            /color/,
            /int/,
            /fixed[0-9]?/,
            /string/,
            /id/,
            /list: .*/,
            /dictionary: .*/
          ].each { |pattern| return [] if data.match?(pattern) }

          # TODO: more checking for lists, dictionaries

          [uhoh("Don't understand the type '#{data}'")]
        else
          [uhoh("Expected a string, but got #{data}")]
        end
      end
    end
  end
end
