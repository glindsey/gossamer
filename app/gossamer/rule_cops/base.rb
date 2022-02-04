# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  module RuleCops
    # Base class for all data sanity checkers.
    class Base
      attr_reader :full_data, :path, :options

      include ::Gossamer::Mixins::Assertions
      include ::Gossamer::Mixins::Log
      include ::Gossamer::Mixins::SmartMerge

      def initialize(full_data, path: [], **options)
        @full_data = full_data
        @path = path
        @options = options

        set_default_options
      end

      def check
        log("Checking \"#{pathname}\"...")
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

        check_log('The dig attempt failed', level: :error) if @data.nil?

        @data
      end

      def replace_data_with(val)
        path[0..-2].inject(@full_data, :fetch)[path.last] = val
        @data = nil # clear cached data so it is retrieved again on next request
      end

      def replace_key_value_with(key, val)
        path.inject(@full_data, :fetch)[key] = val
        @data = nil # clear cached data so it is retrieved again on next request
      end

      def expect(type)
        data.is_a?(type) ? [] : log_expected(type)
      end

      def expect_one_of(types)
        if types.any? { |type| data.is_a?(type) }
          []
        else
          log_expected_one_of(types)
        end
      end

      def check_log(message, level: :info)
        log(checking(message), level: level)
      end

      def log_expected(type)
        check_log("Expected #{type} but got #{data.class} " \
                  "(#{data.inspect})", level: :warning)
      end

      def log_expected_one_of(types)
        check_log("Expected one of #{types.inspect} but got #{data.class} " \
                  "(#{data.inspect})", level: :warning)
      end

      def log_selfref
        check_log('References itself, but that is not allowed', level: :warning)
      end

      def log_missing(key)
        check_log("References '#{key}', but that is not defined in the ruleset",
                  level: :warning)
      end

      def log_nyi(key)
        check_log("'#{key}' is not yet implemented", level: :todo)
      end

      def log_unknown(key)
        check_log("don't know how to interpret '#{key}'", level: :warning)
      end

      private

      def checking(description)
        "Checking \"#{pathname}\": #{description}"
      end

      # Standard checks for root groups.
      def check_root_group(subkey_checker_class)
        if data.is_a?(Hash)
          data.each do |(unit, _)|
            subkey_checker_class.new(
              full_data, path: path + [unit]
            ).check
          end
        else
          log_expected(Hash)
        end
      end

      # Performs standard type checks. If the data is a hash, iterates over the
      # hash calling the provided block.
      def check_subkeys
        raise 'No block provided to #check_subkeys' unless block_given?

        case data
        when TrueClass
          check_log('Converting "true" to an empty hash')
          replace_data_with({})
        when Hash
          data.each { |(key, value)| yield(key, value) }
        else
          log_expected([Hash, TrueClass])
        end
      end

      # Handle `inherits_from` and `is_a_kind_of` tags.
      # The only difference is that `inherits_from` is removed from the target
      # definition, while `is_a_kind_of` is retained.
      def process_inheritance
        unless %w[inherits_from is_a_kind_of].any? { |key| data.key?(key) }
          return
        end

        unless path.size == 2
          check_log("Can't inherit at this hash level", level: :warning)
          return
        end

        replace_key_value_with(
          'inherits_from',
          smart_merge(
            data['inherits_from'],
            data['is_a_kind_of']
          )
        )

        # @todo Double-check this. I'm pretty sure inheritance loops could cause
        #       an infinite loop here.
        while data.key?('inherits_from') && data['inherits_from'].present?
          targets = data['inherits_from']
          category = path.first
          case targets
          when Array
            targets.each { |key| inherit_from(category, key) }
          when String
            inherit_from(category, targets)
          else
            log_expected_one_of([String, Array])
          end
        end
      end

      def inherit_from(category, key)
        check_log("-- Merging data from #{category}.#{key} into #{pathname}",
                  level: :debug)

        unless full_data[category].key?(key)
          return log_missing("#{category}.#{key}")
        end

        inherited_data =
          smart_merge(
            full_data[category][key].except('abstract!'),
            { 'inherits_from' => full_data[category]['is_a_kind_of'] }
          )

        replace_data_with(
          smart_merge(inherited_data, data.except('inherits_from'))
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
