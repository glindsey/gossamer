# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for the root of the data tree.
    class Root < Base
      include Gossamer::Mixins::Log

      def initialize(full_data, path: [])
        super
      end

      protected

      def _check
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
              log_unknown(key)
            end

          checker_class&.check(full_data, path: [key])
        end
      end
    end
  end
end
