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
          log += missing(data) unless category_data.key?(data)

          log += selfref if data == path[-1]
        when Array
          data.each do |subval|
            next if category_data.key?(subval)

            log += missing(subval)
          end
        when Hash
          data.each do |key, _|
            next if category_data.key?(key)

            log += missing(key)
          end
        else
          expected_one_of([String, Array])
        end

        log
      end
    end
  end
end
