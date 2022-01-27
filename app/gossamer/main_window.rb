# frozen_string_literal: true

require 'gosu'

require_relative '../gossamer'

module Gossamer
  # The game window.
  class MainWindow < Gosu::Window
    def initialize
      @x_size = 1706
      @y_size = 960

      super(@x_size, @y_size)
      self.caption = 'The Gossamer Project'

      @root_window = Gui::RootWindow.new(width: @x_size, height: @y_size)
    end

    def update
      # ...
    end

    def draw
      # ...
    end
  end
end
