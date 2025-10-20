require "tty-table"
require "pastel"

module Mastermind
  module Board
    class Board
      HEADERS = ["Turn", "Guess Pegs (Code)", "Feedback"].freeze
      MAX_TURNS = 12
      CODE_LENGTH = 4

      def initialize(game_data)
        @pastel = Pastel.new

        rows = game_data.each_with_index.map do |data, turn|
          pegs = data[:code].map { |color| @pastel.decorate("●", color) }.join(" ")
          feedback = data[:feedback].map { |color| @pastel.decorate("○", color) }.join(" ")
          [(turn + 1).to_s, pegs, feedback]
        end

        @table = TTY::Table.new(header: HEADERS, rows: rows)
      end

      def paint
        puts @table.render(:unicode, padding: [0, 8], alignment: [:center]) do |renderer|
          renderer.border do
            separator :each_row
          end
        end
      end
    end
  end
end
