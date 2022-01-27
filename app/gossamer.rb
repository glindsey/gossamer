# frozen_string_literal: true

require 'zeitwerk'

# Setup file for the Gossamer project.

# The namespace for all game code.
module Gossamer
  VERSION = '0.1.0'
end

# require_relative '../app/gossamer/main_window'
# require_relative '../app/gossamer/version'

# Set up Zeitwerk.
loader = Zeitwerk::Loader.new
loader.push_dir('app')
loader.setup # ready!
