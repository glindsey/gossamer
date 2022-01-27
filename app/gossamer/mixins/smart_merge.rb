# frozen_string_literal: true

module Gossamer
  module Mixins
    module SmartMerge
      # A better deep-merge that handles multiple data types.
      def smart_merge(old_data, new_data)
        case old_data
        when Hash
          smart_merge_into_hash(old_data, new_data)
        when Array
          smart_merge_into_array(old_data, new_data)
        else
          smart_merge_into_scalar(old_data, new_data)
        end
      end

      def smart_merge_into_hash(old_data, new_data)
        case new_data
        when Hash
          all_keys = old_data.keys | new_data.keys
          all_keys.each_with_object({}) do |key, hsh|
            hsh[key] =
              if old_data.key?(key) && new_data.key?(key)
                smart_merge(old_data[key], new_data[key])
              elsif old_data.key?(key)
                old_data[key]
              else
                new_data[key]
              end
          end
        when Array
          [old_data] & new_data
        else
          raise TypeError,
                "Can't merge the hash #{old_data} " \
                "with the #{new_data.class} #{new_data}"
        end
      end

      def smart_merge_into_array(old_data, new_data)
        case new_data
        when Array
          # Arrays in the YAML act as sets.
          old_data | new_data
        else
          old_data | [new_data]
        end
      end

      def smart_merge_into_scalar(old_data, new_data)
        case new_data
        when Hash
          raise TypeError,
                "Can't merge the #{old_data.class} #{old_data} " \
                "with the hash #{new_data}"
        when Array
          [old_data] | new_data
        else
          [old_data, new_data]
        end
      end
    end
  end
end
