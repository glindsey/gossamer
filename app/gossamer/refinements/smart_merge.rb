# frozen_string_literal: true

module Gossamer
  module Refinements
    # Refinements to add smart-merge capabilities to classes.
    # @warning This concern treats arrays as sets!
    module SmartMerge
      using Refinements::ObjectToKeysOfHash

      refine ::Hash do
        # rubocop:disable Metrics/PerceivedComplexity
        def smart_merge(new_data, strict: false)
          return new_data if blank? && new_data.is_a?(Hash) && !strict

          if strict && !new_data.is_a?(Hash)
            raise TypeError,
                  "Can't merge the Hash #{inspect} " \
                  "with the #{new_data.class} #{new_data.inspect}"
          end

          new_data = new_data.to_keys_of_hash

          all_keys = keys | new_data.keys

          all_keys.each_with_object({}) do |key, hsh|
            hsh[key] =
              if key?(key) &&
                 new_data.key?(key) &&
                 !new_data[key].nil?
                self[key].smart_merge(new_data[key], strict:)
              elsif key?(key)
                self[key]
              else
                new_data[key]
              end
          end
        end
        # rubocop:enable Metrics/PerceivedComplexity
      end

      refine ::Array do
        def smart_merge(new_data, strict: false)
          return new_data if blank? && new_data.is_a?(Array) && !strict

          return self | new_data if new_data.is_a?(Array)

          return self | [new_data] unless strict

          raise TypeError,
                "Can't merge the Array #{inspect} " \
                "with the #{new_data.class} #{new_data.inspect}"
        end
      end

      refine ::Object do
        def smart_merge(new_data, strict: false)
          case new_data
          when Hash
            raise TypeError,
                  "Can't merge the #{self.class} #{inspect} " \
                  "with the Hash #{new_data.inspect}"
          when Array
            return [self] | new_data unless strict

            raise TypeError,
                  "Can't merge the #{self.class} #{inspect} " \
                  "with the Array #{new_data.inspect}"
          else
            strict ? [self, new_data] : new_data
          end
        end
      end
    end
  end
end
