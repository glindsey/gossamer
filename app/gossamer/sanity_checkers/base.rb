# frozen_string_literal: true

module Gossamer
  module SanityCheckers
    # Base class for all data sanity checkers.
    class Base
      attr_reader :full_data, :path

      include ::Gossamer::Mixins::Assertions

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
        return @data if @data

        assert { @full_data.is_a?(Hash) }
        assert { @path.is_a?(Array) }
        assert { @path.all?(String) }

        @data = path.present? ? @full_data.dig(*@path) : @full_data

        uhoh('The dig attempt failed') if @data.nil?

        @data
      end

      def replace_data_with(val)
        path[0..-2].inject(@full_data, :fetch)[path.last] = val
      end

      def note(description)
        "   NOTE: While checking \"#{pathname}\": #{description}"
      end

      def uhoh(description)
        "WARNING: While checking \"#{pathname}\": #{description}"
      end

      private

      # Standard checks for root groups.
      def check_root_group(subkey_checker_class)
        log = []

        if data.is_a?(Hash)
          data.each do |(unit, _)|
            log += subkey_checker_class.new(
              full_data, path: path + [unit]
            ).check
          end
        else
          log.push(
            uhoh("Expected a hash but got a #{data.class}")
          )
        end

        log
      end

      # Performs standard type checks. If the data is a hash, iterates over the
      # hash calling the provided block.
      def check_subkeys
        raise 'No block provided to #check_subkeys' unless block_given?

        log = []

        case data
        when TrueClass
          log.push(note('Converting "true" to an empty hash'))
          replace_data_with({})
        when Hash
          data.each do |(key, value)|
            result = yield(key, value) if block_given?
            log += result if result.present?
          end
        else
          log.push(uhoh("Expected a hash or 'true', but got #{data.inspect}"))
        end

        log
      end

      def _check
        raise NotImplementedError,
              uhoh("The class #{self.class} does not yet implement #_check")
      end
    end
  end
end
