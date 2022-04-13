# frozen_string_literal: true

module Gossamer
  module World
    # A pool that stores relationships of things to other things.
    # This pool indexes relations via source, target, and type.
    class RelationPool
      include Concerns::SymbolToGossamerClass

      def initialize(thing_pool:)
        @thing_pool = thing_pool
      end

      # Get a relation via its own UUID.
      def [](id)
        raise 'Index must be a String' unless id.is_a?(String)

        @pool.fetch(id, nil)
      end

      def create(thing_a, relation_type, thing_b, **_options)
        thing_a = get_from_pool(thing_a)
        thing_b = get_from_pool(thing_b)
        relation_class = relationify(relation_type)
        relation_symbol = degossamerify(relation_type)
        id = SecureRandom.uuid

        # TODO: check for conflicting relation types

        pool[id] = relation_class.new(id, thing_a, thing_b, pool: self)

        # Update indexes.
        @thing_a_index[thing_a.id] ||= Set.new
        @thing_a_index[thing_a.id].add(id)
        @thing_b_index[thing_b.id] ||= Set.new
        @thing_b_index[thing_b.id].add(id)
        @relation_index[relation_symbol] ||= Set.new
        @relation_index[relation_symbol].add(id)
      end

      def delete(id)
        unless id.is_a?(String)
          raise "Argument must be a String, but was #{id.inspect}"
        end

        relation = pool.fetch(id, nil)
        relation_symbol = degossamerify(relation.class)

        if relation.nil?
          raise "Requested relation #{id.inspect} does not exist in the pool"
        end

        # Update indexes.
        @thing_a_index[relation.thing_a]&.delete(id)
        @thing_b_index[relation.thing_b]&.delete(id)
        @relation_index[relation_symbol]&.delete(id)

        @pool.delete(id)
      end

      # Raw pool relating UUIDs to Relations.
      def pool
        @pool ||= {}
      end

      # Relation index on Thing A UUIDs to Relation UUIDs.
      def thing_a_index
        @thing_a_index ||= {}
      end

      # Relation index on Thing B UUIDs to Relation UUIDs.
      def thing_b_index
        @thing_b_index ||= {}
      end

      # Relation index on relation types to Relation UUIDs.
      def relation_index
        @relation_index ||= {}
      end

      private

      def get_from_pool(thing)
        return thing if thing.is_a?(World::Things::Base)

        unless thing.is_a?(String)
          raise "Argument must be a Thing or String, but was #{thing.inspect}"
        end

        thing_pool[thing].tap do |result|
          if result.nil?
            raise "Requested Thing #{thing.inspect} does not exist in the pool"
          end
        end
      end

      attr_reader :thing_pool
    end
  end
end
