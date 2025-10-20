# frozen_string_literal: true

require "tty-font"
require "pastel"

module Mastermind
  module Menu
    class MenuTitle
      TITLE = "Mastermind"

      def initialize
        @font = TTY::Font.new
        @pastel = Pastel.new
      end

      def paint
        puts @pastel.cyan(@font.write(TITLE))
      end
    end
  end
end
