# frozen_string_literal: true

module Gossamer
  module World
    module Things
      module Traits
        # Represents possible physical relationships to another object:
        # - contained by
        # - held by (as in grasped)
        # - supported by (as in "on top of")
        # - part of
        # - worn by
        # These statuses are exclusive to each other.
        module PhysicallyRelatable
          extend ActiveSupport::Concern

          RELATIONS = [
            :contained_by,
            :held_by,
            :supported_by,
            :part_of,
            :worn_by
          ].freeze

          def physical_relation
            @physical_relation = { nil => nil }
          end

          def physical_relation=(rel)
            unless rel.is_a?(Hash) && rel.length == 1
              raise 'Relation must be a single-pair Hash'
            end

            key = rel.keys.first
            value = rel.values.first
            if key.nil? && value.nil?
              @physical_relation = { nil => nil }
              return
            end

            unless RELATIONS.include?(key)
              raise "Relation key must be nil or one of #{RELATIONS.inspect}"
            end

            unless value.is_a?(:physically_relatable)
              raise 'Relation value must nil or be a physically relatable thing'
            end

            @physical_relation = rel
          end
        end
      end
    end
  end
end
