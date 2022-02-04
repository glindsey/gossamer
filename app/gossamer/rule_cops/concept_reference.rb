# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for rules that reference root concepts.
    class ConceptReference < Base
      include Gossamer::Mixins::Log

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
        case data
        when String
          log_missing(data) unless category_data.key?(data)

          log_selfref if data == path[-1]
        when Array
          data.each do |subval|
            next if category_data.key?(subval)

            log_missing(subval)
          end
        when Hash
          data.each do |key, _|
            next if category_data.key?(key)

            log_missing(key)
          end
        else
          log_expected_one_of([String, Array])
        end
      end
    end
  end
end
