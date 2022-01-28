# frozen_string_literal: true

module Gossamer
  module Mixins
    # Mixin to add smart-merge capabilities to classes.
    module SmartMerge
      # A better deep-merge that handles multiple data types.
      def smart_merge(old_data, new_data, strict: false)
        case old_data
        when Hash
          smart_merge_into_hash(old_data, new_data, strict: strict)
        when Array
          smart_merge_into_array(old_data, new_data, strict: strict)
        else
          smart_merge_into_scalar(old_data, new_data, strict: strict)
        end
      end

      def smart_merge_into_hash(old_data, new_data, strict:)
        case new_data
        when Hash
          all_keys = old_data.keys | new_data.keys
          return all_keys.each_with_object({}) do |key, hsh|
            hsh[key] =
              if old_data.key?(key) && new_data.key?(key)
                smart_merge(old_data[key], new_data[key], strict: strict)
              elsif old_data.key?(key)
                old_data[key]
              else
                new_data[key]
              end
          end
        when Array
          return [old_data] | new_data unless strict
        end

        raise TypeError,
              "Can't merge the Hash #{old_data} " \
              "with the #{new_data.class} #{new_data}"
      end

      def smart_merge_into_array(old_data, new_data, strict:)
        # Arrays in the YAML act as sets.
        return old_data | new_data if new_data.is_a?(Array)

        return old_data | [new_data] unless strict

        raise TypeError,
              "Can't merge the Array #{old_data} " \
              "with the #{new_data.class} #{new_data}"
      end

      def smart_merge_into_scalar(old_data, new_data, strict:)
        case new_data
        when Hash
          raise TypeError,
                "Can't merge the #{old_data.class} #{old_data} " \
                "with the Hash #{new_data}"
        when Array
          return [old_data] | new_data unless strict

          raise TypeError,
                "Can't merge the #{old_data.class} #{old_data} " \
                "with the Array #{new_data}"
        else
          strict ? [old_data, new_data] : new_data
        end
      end
    end
  end
end
