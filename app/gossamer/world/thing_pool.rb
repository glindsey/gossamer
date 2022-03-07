# frozen_string_literal: true

module Gossamer
  module World
    # A pool that relates things to UUIDs, allowing for much easier
    # serialization/deserialization of data.
    class ThingPool
      include Concerns::SymbolToGossamerClass

      def [](id)
        @pool.fetch(id, nil)
      end

      def create(thing_type, **options)
        thing_class = thingify(thing_type)
        id = SecureRandom.uuid

        pool[id] = thing_class.new(id, pool: self, **options)
      end

      def delete(id)
        @pool.delete(id)
      end

      def pool
        @pool ||= {}
      end
    end
  end
end
