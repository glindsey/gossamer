# frozen_string_literal: true

require_relative 'component'

module Gossamer
  module Gui
    # The base definition of a GUI component that has child objects.
    class ParentComponent < Component
      attr_reader :children

      # x, y, width, height are relative to the parent component when drawn
      def initialize(width: 0, height: 0, **options)
        super(width:, height:, **options)

        @children = []
      end

      # add a child component to this component's children
      def adopt(child)
        return unless child.is_a?(Component)

        return if @children.include?(child)

        child.parent&.abandon(child)

        child.parent = self
        @children.insert(0, child)
      end

      # remove this child component from this component's children
      def abandon(child)
        return unless child.is_a?(Component)

        return unless @children.include?(child)

        @children.delete(child)
        child.parent = nil
      end

      # Simple draw method; not very useful since children of this base class
      # don't have locations within the parent component, so they're all drawn
      # at (0, 0).
      def _draw(x: 0, y: 0, **draw_options)
        _draw_background_layer(x:, y:, **draw_options)
        _draw_children(x:, y:, **draw_options)
        _draw_foreground_layer(x:, y:, **draw_options)
      end

      protected

      # Child drawing method to be overriden by subclasses.
      # The default one isn't very useful since children in the generic "parent"
      # component don't have locations within the parent component, so they are
      # all drawn at the parent's origin.
      def _draw_children(x: 0, y: 0, **draw_options)
        children.each do |child|
          child._draw(x:, y:, **draw_options)
        end
      end

      attr_writer :parent
    end
  end
end
