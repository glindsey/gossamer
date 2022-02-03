# frozen_string_literal: true

require 'zeitwerk'

# Setup file for the Gossamer project.

# The namespace for all game code.
module Gossamer
  # @todo Find a way to specify this dynamically
  def development?
    true
  end

  # @todo Find a way to specify this dynamically
  def test?
    false
  end
end

# require_relative '../app/gossamer/main_window'
# require_relative '../app/gossamer/version'

# Set up Zeitwerk.
loader = Zeitwerk::Loader.new
loader.push_dir('app')
loader.setup # ready!
