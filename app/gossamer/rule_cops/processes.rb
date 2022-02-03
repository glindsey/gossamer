# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for processes data under other tags.
    class Processes < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        ::Gossamer::RuleCops::ConceptReference.new(
          full_data, category: 'processes', path: path
        ).check

        check_subkeys do |key, _|
          ::Gossamer::RuleCops::Process.new(
            full_data, path: path + [key]
          ).check
        end
      end
    end
  end
end
