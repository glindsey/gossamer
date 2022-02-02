# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Sanity checker for the root of the data tree.
    class Root < Base
      def initialize(full_data, path: [])
        super
      end

      protected

      def _check
        log = []

        data.each do |(key, _)|
          checker_class =
            case key
            when 'attributes'
              ::Gossamer::SanityCheckers::RootAttributes
            when 'materials'
              ::Gossamer::SanityCheckers::RootMaterials
            when 'measurements'
              ::Gossamer::SanityCheckers::RootMeasurements
            when 'processes'
              ::Gossamer::SanityCheckers::RootProcesses
            when 'properties'
              ::Gossamer::SanityCheckers::RootProperties
            when 'senses'
              ::Gossamer::SanityCheckers::RootSenses
            when 'things'
              ::Gossamer::SanityCheckers::RootThings
            when 'units'
              ::Gossamer::SanityCheckers::RootUnits
            else
              log.push(
                "(root): \"#{key}\" is not recognized and will be ignored"
              )
              nil
            end

          log += checker_class&.new(full_data, path: [key])&.check
        end

        log
      end
    end
  end
end
