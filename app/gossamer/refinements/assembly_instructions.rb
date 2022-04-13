# frozen_string_literal: true

module Gossamer
  module Refinements
    # Refinements that simplify manipulating "assembly instructions" for Things.
    module AssemblyInstructions
      using Refinements::SmartMerge

      refine ::Hash do
        def add_part(to: [], parts: {})
          dig_chain = to.map { |element| [:parts, element] }.flatten
          part_to_add_to = dig(*dig_chain)

          if part_to_add_to.nil?
            Services::Logger.log(
              "While trying to add #{parts.inspect}: " \
              "can't find #{to.inspect} in #{inspect}!",
              level: :warning
            )
            return self
          end

          part_to_add_to[:parts] ||= {}
          part_to_add_to[:parts] = part_to_add_to[:parts].smart_merge(parts)

          self
        end
      end
    end
  end
end
