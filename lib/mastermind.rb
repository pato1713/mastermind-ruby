# frozen_string_literal: true

# Add lib directory to load path
lib_path = File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require "mastermind/game"

module Mastermind
  class Error < StandardError; end

  def self.start
    Game.new.start
  end
end
