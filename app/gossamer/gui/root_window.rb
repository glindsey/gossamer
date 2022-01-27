# frozen_string_literal: true

require_relative 'parent_component'

module Gossamer
  module Gui
    # The root window for the GUI.
    class RootWindow < ParentComponent
      # Does the actual drawing of the component.
      def _draw(x: 0, y: 0, **draw_options)
        _draw_background_layer(x: x, y: y, **draw_options)
        _draw_foreground_layer(x: x, y: y, **draw_options)
      end

      protected

      def _draw_background_layer(x: 0, y: 0, **draw_options)
        # Default behavior does nothing
      end

      def _draw_foreground_layer(x: 0, y: 0, **draw_options)
        # Default behavior does nothing
      end
    end
  end
end
