# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a built-in type.
    class BuiltinType < Base
      PATTERNS = [
        { regex: /^bool(ean)?$/, replacement: 'bool' },
        { regex: /^color$/, replacement: 'color' },
        { regex: /^enum(erat(ed|ion))?$/, replacement: 'enum' },
        { regex: /^int(eger)?$/, replacement: 'int' },
        { regex: /^fixed/, replacement: 'fixed' },
        { regex: /^str(ing)?$/, replacement: 'str' },
        { regex: /^id$/, replacement: 'id' },
        { regex: /^list:\s*/, replacement: 'list: ' },
        { regex: /^dict(ionary)?:\s*/, replacement: 'dict: ' }
      ].freeze

      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        if data.is_a?(String)
          okay = false
          PATTERNS.each do |pattern|
            next unless data.match?(pattern[:regex])

            okay = true
            replace_data_with(data.sub(pattern[:regex], pattern[:replacement]))
            break
          end

          # TODO: more checking for lists, dictionaries
          log += uhoh("Don't understand the type '#{data}'") unless okay
        else
          log += uhoh("Expected a string, but got #{data}")
        end

        log
      end
    end
  end
end
