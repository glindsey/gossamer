# frozen_string_literal: true

module Gossamer
  module Refinements
    # Refinements to allow easy conversion of any object into a hash.
    module ObjectToKeysOfHash
      refine ::Object do
        def to_keys_of_hash(value = true) # rubocop:disable Style/OptionalBooleanParameter
          { self => value }
        end
      end

      refine ::Array do
        def to_keys_of_hash(value = true) # rubocop:disable Style/OptionalBooleanParameter
          to_h { |item| [item, value] }
        end
      end

      refine ::Hash do
        def to_keys_of_hash(_)
          self
        end
      end
    end
  end
end
