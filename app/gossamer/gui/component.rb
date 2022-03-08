# frozen_string_literal: true

require 'active_support/all'
require 'gosu'
require 'set'

require_relative '../gui'

module Gossamer
  module Gui
    # The base definition of a GUI component.
    # Although a component has a width and height, it does *not* have a position
    # of its own; the position is determined by its parent component.
    class Component
      attr_reader :width, :height, :options, :parent, :dirty

      # x, y are relative to the parent component when drawn
      # (width, height may be relative or absolute depending on the subclass )
      def initialize(width: 0, height: 0, **options)
        @width = width
        @height = height
        @options = options
        @parent = nil
        @dirty = false
      end

      # Only draws the component if it is marked as dirty (needing redraw).
      def draw(x: 0, y: 0, **draw_options)
        return unless @dirty

        _draw(x:, y:, **draw_options)

        @dirty = false
      end

      # Dirty setter also sets "dirty" for any parent components
      def mark_as_dirty
        @dirty = true
        parent&.mark_as_dirty
      end

      # Does the actual drawing of the component.
      def _draw(x: 0, y: 0, **draw_options)
        _draw_background_layer(x:, y:, **draw_options)
        _draw_foreground_layer(x:, y:, **draw_options)
      end

      protected

      attr_writer :parent

      def _draw_background_layer(x: 0, y: 0, **draw_options)
        # Default behavior does nothing
      end

      def _draw_foreground_layer(x: 0, y: 0, **draw_options)
        # Default behavior does nothing
      end
    end
  end
end
