# frozen_string_literal: true

module Gossamer
  module RuleCops
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
              ::Gossamer::RuleCops::RootAttributes
            when 'materials'
              ::Gossamer::RuleCops::RootMaterials
            when 'measurements'
              ::Gossamer::RuleCops::RootMeasurements
            when 'processes'
              ::Gossamer::RuleCops::RootProcesses
            when 'properties'
              ::Gossamer::RuleCops::RootProperties
            when 'senses'
              ::Gossamer::RuleCops::RootSenses
            when 'things'
              ::Gossamer::RuleCops::RootThings
            else
              log += unknown(key)
            end

          log += checker_class&.check(full_data, path: [key])
        end

        log
      end
    end
  end
end
