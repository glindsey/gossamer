# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Base class for all data sanity checkers.
    class Base
      attr_reader :full_data, :path, :options

      include ::Gossamer::Mixins::Assertions

      def initialize(full_data, path: [], **options)
        @full_data = full_data
        @path = path
        @options = options

        set_default_options
      end

      def check
        warn "Checking \"#{pathname}\"..."
        _check
      end

      def self.check(full_data, path: [])
        new(full_data, path: path).check
      end

      def pathname
        @path.present? ? @path.join('.') : '(root)'
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
        if @options[:note]
          ["   NOTE: While checking \"#{pathname}\": #{description}"]
        else
          []
        end
      end

      def todo(description)
        if @options[:todo]
          ["   TODO: While checking \"#{pathname}\": #{description}"]
        else
          []
        end
      end

      def uhoh(description)
        ["WARNING: While checking \"#{pathname}\": #{description}"]
      end

      def nyi(key)
        todo("'#{key}' is not yet implemented")
      end

      def unknown(key)
        uhoh("don't know how to interpret '#{key}'")
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
          log += uhoh("Expected a hash but got a #{data.class}")
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
          log += note('Converting "true" to an empty hash')
          replace_data_with({})
        when Hash
          data.each do |(key, value)|
            result = yield(key, value) if block_given?
            case result
            when Array
              log += result if result.present?
            else
              log += [result] if result.present?
            end
          end
        else
          log += uhoh("Expected a hash or 'true', but got #{data.inspect}")
        end

        log
      end

      def _check
        raise NotImplementedError,
              "The class #{self.class} does not yet implement #_check"
      end

      def set_default_options
        @options[:note] = true unless @options.key?(:note)
        @options[:todo] = false unless @options.key?(:todo)
      end
    end
  end
end
