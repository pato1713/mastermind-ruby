# frozen_string_literal: true

# Add lib directory to load path
lib_path = File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require "mastermind/menu/menu"
require "mastermind/menu/menu_title"
require "mastermind/board/board"
require "mastermind/helpers"

module Mastermind
  class Error < StandardError; end

  class Game
    include Helpers
    def initialize
      @menu = Menu::Menu.new
      @board = Board::Board.new
      @title = Menu::MenuTitle.new
    end

    def start
      @menu.paint
      return if @menu.choice == :exit

      main_loop
    end

    def main_loop
      clear_screen
      @title.paint
      @board.paint
    end
  end

  def self.start
    Game.new.start
  end
end
