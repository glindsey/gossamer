# frozen_string_literal: true

module Gossamer
  module Concerns
    # Mixin to add smart-merge capabilities to classes.
    # @warning This concern treats arrays as sets!
    module SmartMerge
      extend ActiveSupport::Concern
      using Refinements::ObjectToKeysOfHash

      delegate :smart_merge, :smart_merge_into_hash,
               :smart_merge_into_array, :smart_merge_into_scalar,
               to: :class

      class_methods do
        # A better deep-merge that handles multiple data types.
        def smart_merge(old_data, new_data, strict: false)
          case old_data
          when Hash
            if old_data.blank? && new_data.is_a?(Hash) && !strict
              return new_data
            end

            smart_merge_into_hash(old_data, new_data, strict: strict)
          when Array
            if old_data.blank? && new_data.is_a?(Array) && !strict
              return new_data
            end

            smart_merge_into_array(old_data, new_data, strict: strict)
          else
            smart_merge_into_scalar(old_data, new_data, strict: strict)
          end
        end

        def smart_merge_into_hash(old_data, new_data, strict:)
          if strict && !new_data.is_a?(Hash)
            raise TypeError,
                  "Can't merge the Hash #{old_data.inspect} " \
                  "with the #{new_data.class} #{new_data.inspect}"
          end

          new_data = new_data.to_keys_of_hash

          all_keys = old_data.keys | new_data.keys

          all_keys.each_with_object({}) do |key, hsh|
            hsh[key] = if old_data.key?(key) &&
                          new_data.key?(key) &&
                          !new_data[key].nil?
                         smart_merge(
                           old_data[key], new_data[key], strict: strict
                         )
                       elsif old_data.key?(key)
                         old_data[key]
                       else
                         new_data[key]
                       end
          end
        end

        def smart_merge_into_array(old_data, new_data, strict:)
          return old_data | new_data if new_data.is_a?(Array)

          return old_data | [new_data] unless strict

          raise TypeError,
                "Can't merge the Array #{old_data.inspect} " \
                "with the #{new_data.class} #{new_data.inspect}"
        end

        def smart_merge_into_scalar(old_data, new_data, strict:)
          case new_data
          when Hash
            raise TypeError,
                  "Can't merge the #{old_data.class} #{old_data.inspect} " \
                  "with the Hash #{new_data.inspect}"
          when Array
            return [old_data] | new_data unless strict

            raise TypeError,
                  "Can't merge the #{old_data.class} #{old_data.inspect} " \
                  "with the Array #{new_data.inspect}"
          else
            strict ? [old_data, new_data] : new_data
          end
        end
      end
    end
  end
end
