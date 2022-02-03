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
          log += uhoh("Expected a string or array, but got #{data}")
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
          log += uhoh("Expected a string or single-pair hash, but got #{data}")
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
          log += uhoh("References 'attributes.#{attr_name}', " \
                      'but that is not defined')
        end
        if attr_name == path[-1]
          log += uhoh('References itself, but this is not allowed')
        end

        log
      end
    end
  end
end
