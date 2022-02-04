# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for rules that reference attributes.
    class AttributeReference < Base
      include Gossamer::Mixins::Log

      def initialize(full_data, path: [])
        super
      end

      def attrs_data
        full_data['attributes'] || {}
      end

      def _check
        case data
        when String
          check_one(data)
        when Array
          data.each { |subval| check_one(subval) }
        when Hash
          data.each { |(key, value)| check_hash_pair(key, value) }
        else
          log_expected_one_of([String, Array, Hash])
        end
      end

      private

      def check_one(line)
        case line
        when String
          check_attr_name(line)
        when Hash
          if line.size != 1
            check_log("Got #{line}, but a hash inside an array can only have " \
                      'one key/value pair', level: :warning)
          end

          check_hash_pair(line.keys.first, line.values.first)
        else
          log_expected_one_of([String, Hash])
        end
      end

      def check_hash_pair(key, _value)
        check_attr_name(key)
        # TODO: check that the set value is valid for the attribute
      end

      def check_attr_name(attr_name)
        log_missing("attributes.#{attr_name}") unless attrs_data.key?(attr_name)

        log_selfref if attr_name == path[-1]
      end
    end
  end
end
