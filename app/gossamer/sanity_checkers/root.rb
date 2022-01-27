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
              ::Gossamer::SanityCheckers::Attributes
            when 'materials'
              ::Gossamer::SanityCheckers::Materials
            when 'measurements'
              ::Gossamer::SanityCheckers::Measurements
            when 'processes'
              ::Gossamer::SanityCheckers::Processes
            when 'properties'
              ::Gossamer::SanityCheckers::Properties
            when 'senses'
              ::Gossamer::SanityCheckers::Senses
            when 'traits'
              ::Gossamer::SanityCheckers::Traits
            when 'things'
              ::Gossamer::SanityCheckers::Things
            when 'units'
              ::Gossamer::SanityCheckers::Units
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
