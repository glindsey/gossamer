# frozen_string_literal: true

require 'zeitwerk'

ROOT_DIR = __dir__
COMMON_REQUIRES = File.join(ROOT_DIR, 'common.rb')

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

# Load all the mod directories.
mod_directories =
  Dir[File.join(ROOT_DIR, '..', 'mods', '*')] |
  Dir[File.join(ROOT_DIR, '..', 'experimental', 'mods', '*')]

mod_directories.each do |dir|
  loader.push_dir(dir) if File.directory?(dir)
end

# Ready to go!
loader.setup

# This slows startup down, but verifies that I didn't screw anything up majorly
loader.eager_load
