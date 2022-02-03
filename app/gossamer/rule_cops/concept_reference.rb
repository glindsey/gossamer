# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for rules that reference root concepts.
    class ConceptReference < Base
      attr_reader :category

      def initialize(full_data, category:, path: [])
        super(full_data, path: path)

        @category = category
      end

      def self.check(full_data, category:, path: [])
        new(full_data, category: category, path: path).check
      end

      def category_data
        full_data[@category] || {}
      end

      def _check
        log = []

        case data
        when String
          unless category_data.key?(data)
            log += uhoh("References '#{@category}.#{data}', " \
                        'but that is not defined')
          end
          if data == path[-1]
            log += uhoh('References itself, but this is not allowed')
          end
        when Array
          data.each do |subval|
            next if category_data.key?(subval)

            log += uhoh("References '#{@category}.#{subval}', " \
                        'but that is not defined')
          end
        when Hash
          data.each do |key, _|
            next if category_data.key?(key)

            log += uhoh("References '#{@category}.#{key}', " \
                        'but that is not defined')
          end
        else
          log += uhoh("Expected a string or array, but got #{data.inspect}")
        end

        log
      end
    end
  end
end
