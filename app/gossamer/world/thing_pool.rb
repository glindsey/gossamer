# frozen_string_literal: true

module Gossamer
  module World
    # A pool that relates things to UUIDs, allowing for much easier
    # serialization/deserialization of data.
    #
    # Also contains a relations pool which is tied to it.
    class ThingPool
      attr_reader :relations

      include Concerns::SymbolToGossamerClass

      def [](id)
        raise 'Index must be a String' unless id.is_a?(String)

        @pool.fetch(id, nil)
      end

      def create(thing_type, **options)
        unless [Symbol, Class].any? { |type| thing_type.is_a?(type) }
          msg = 'Thing type must be a Symbol or Class, but was ' \
                "#{thing_type.inspect}"
          if thing_type.nil?
            msg += ' (probably missing a Thing class definition)'
          end

          raise msg
        end

        thing_class = thingify(thing_type)
        id = SecureRandom.uuid

        pool[id] = thing_class.new(id, pool: self, **options)
      end

      def delete(id)
        raise 'Provided parameter must be a String' unless id.is_a?(String)

        @pool.delete(id)
      end

      # Raw pool relating UUIDs to Things.
      def pool
        @pool ||= {}
      end

      # RelationPool instance.
      def relations
        @relations ||= RelationPool.new(thing_pool: self)
      end
    end
  end
end
