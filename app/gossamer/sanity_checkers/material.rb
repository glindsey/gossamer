# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for a single material.
    class Material < Base
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
                full_data, category: 'materials', path: path + [key]
              ).check
            end
          end
        end

        log
      end

      private

      def check_is_kind_of(value, log)
        materials = full_data['materials']

        case value
        when String
          unless materials.key?(value)
            log.push(
              uhoh("Defined as a kind of '#{value}', but that is not defined")
            )
          end
        when Array
          value.each do |subval|
            next if materials.key?(subval)

            log.push(
              uhoh("Defined as a kind of '#{subval}', but that is not defined")
            )
          end
        else
          log.push(
            uhoh("'is_a_kind_of' expects a string or array, not #{value}")
          )
        end
      end

    end
  end
end
