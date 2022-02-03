# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for rules that reference attributes.
    class AttributeReference < Base
      def initialize(full_data, path: [])
        super
      end

      def attrs_data
        full_data['attributes'] || {}
      end

      def _check
        log = []

        case data
        when String
          log += check_one(data)
        when Array
          data.each { |subval| log.push(check_one(subval)) }
        when Hash
          data.each { |(key, value)| log.push(check_hash_pair(key, value)) }
        else
          expected_one_of([String, Array, Hash])
        end

        log
      end

      private

      def check_one(line)
        log = []

        case line
        when String
          log += check_attr_name(line)
        when Hash
          if line.size != 1
            log += uhoh("Got #{line}, but a hash inside an array can only " \
                        'have one key/value pair')
          end

          log += check_hash_pair(line.keys.first, line.values.first)
        else
          expected_one_of([String, Hash])
        end

        log
      end

      def check_hash_pair(key, _value)
        log = []

        log += check_attr_name(key)
        # TODO: check that the set value is valid for the attribute

        log
      end

      def check_attr_name(attr_name)
        log = []

        unless attrs_data.key?(attr_name)
          log += missing("attributes.#{attr_name}")
        end
        log += selfref if attr_name == path[-1]

        log
      end
    end
  end
end
