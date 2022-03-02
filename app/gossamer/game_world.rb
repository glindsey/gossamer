# frozen_string_literal: true

require_relative '../gossamer'

module Gossamer
  # Instance of the game world.
  class GameWorld
    attr_reader :rules

    def initialize
      @rules = ::Gossamer::Rules.new(__dir__)
    end
  end
end
