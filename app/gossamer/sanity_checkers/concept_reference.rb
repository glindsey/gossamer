# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for rules that reference root concepts.
    class ConceptReference < Base
      attr_reader :category

      def initialize(full_data, category:, path: [])
        super(full_data, path: path)

        @category = category
      end

      def category_data
        full_data[@category] || {}
      end

      def _check
        log = []

        case data
        when String
          unless category_data.key?(data)
            log.push(
              uhoh("References '#{@category}.#{data}', " \
                   'but that is not defined')
            )
          end
          if data == path[-1]
            log.push(
              uhoh('References itself, but this is not allowed')
            )
          end
        when Array
          data.each do |subval|
            next if category_data.key?(subval)

            log.push(
              uhoh("References '#{@category}.#{subval}', " \
                   'but that is not defined')
            )
          end
        else
          log.push(
            uhoh("Expected a string or array, but got #{data}")
          )
        end

        log
      end
    end
  end
end
