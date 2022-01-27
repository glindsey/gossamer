# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Base class for all data sanity checkers.
    class Base
      attr_reader :full_data, :path

      def initialize(full_data, path: [])
        @full_data = full_data
        @path = path
      end

      def check
        warn "Checking \"#{pathname}\"..."
        _check
      end

      def pathname
        @path.join('.')
      end

      def data
        data ||= path.present? ? @full_data.dig(*@path) : @full_data

        uhoh('The dig attempt failed') if data.nil?

        data
      end

      def uhoh(description)
        "When trying to sanity-check \"#{pathname}\": #{description}"
      end

      private

      def _check
        raise NotImplementedError,
              uhoh("The class #{self.class} does not yet implement #_check")
      end
    end
  end
end
