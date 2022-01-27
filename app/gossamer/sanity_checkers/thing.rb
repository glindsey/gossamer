# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a single thing.
    class Thing < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        log = []

        if data.is_a?(Hash)
          data.each do |(key, value)|
            case key
            when 'abstract!'
              unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
                log.push(uhoh("#{value} isn't a boolean value"))
              end
            when 'is_a_kind_of'
              log += ::Gossamer::SanityCheckers::IsAKindOf.new(
                full_data, category: 'things', path: path + [key]
              ).check
            end
          end
        end

        log
      end
    end
  end
end
