# frozen_string_literal: true

require "tty-font"
require "pastel"

module Mastermind
  class Title
    TITLE = "Mastermind"

    def initialize
      @font = TTY::Font.new
      @pastel = Pastel.new
    end

    def show
      puts @pastel.cyan(@font.write(TITLE))
    end
  end
end
