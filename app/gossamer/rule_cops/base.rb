# frozen_string_literal: true

require COMMON

module Gossamer
  module RuleCops
    # Base class for all data sanity checkers.
    class Base
      attr_reader :full_data, :path, :options

      include ::Gossamer::Mixins::Assertions
      include ::Gossamer::Mixins::SmartMerge

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
        @data = nil # clear cached data so it is retrieved again on next request
      end

      def note(description)
        if @options[:note]
          ["   NOTE: #{checking(description)}"]
        else
          []
        end
      end

      def todo(description)
        if @options[:todo]
          ["   TODO: #{checking(description)}"]
        else
          []
        end
      end

      def uhoh(description)
        ["WARNING: #{checking(description)}"]
      end

      def expect(type)
        data.is_a?(type) ? [] : expected(type)
      end

      def expect_one_of(types)
        if types.any? { |type| data.is_a?(type) }
          []
        else
          expected_one_of(types)
        end
      end

      def expected(type)
        uhoh("Expected #{type} but got #{data.class} " \
             "(#{data.inspect})")
      end

      def expected_one_of(types)
        uhoh("Expected one of #{types.inspect} but got #{data.class} " \
             "(#{data.inspect})")
      end

      def selfref
        uhoh('References itself, but that is not allowed')
      end

      def missing(key)
        uhoh("References '#{key}', but that is not defined in the ruleset")
      end

      def nyi(key)
        todo("'#{key}' is not yet implemented")
      end

      def unknown(key)
        uhoh("don't know how to interpret '#{key}'")
      end

      private

      def checking(description)
        "Checking \"#{pathname}\": #{description}"
      end

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
          expected(Hash)
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
          expected([Hash, TrueClass])
        end

        log
      end

      # Handle `inherits` tags.
      def process_inheritance
        return uhoh("Can't inherit at this hash level") unless path.size == 2

        log = []

        # @todo Double-check this. I'm pretty sure inheritance loops could cause
        #       an infinite loop here.
        while data.key?('inherits')
          targets = data['inherits']
          category = path.first
          case targets
          when Array
            targets.each { |key| log += inherit_from(category, key) }
          when String
            log += inherit_from(category, targets)
          else
            log += expected_one_of([String, Array])
          end
        end

        log
      end

      def inherit_from(category, key)
        warn "-- Merging data from #{category}.#{key} into #{pathname}"

        unless full_data[category].key?(key)
          return missing("#{category}.#{key}")
        end

        inherited_data = full_data[category][key]

        replace_data_with(
          smart_merge(
            inherited_data.except('abstract!'),
            data.except('inherits')
          )
        )

        []
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
