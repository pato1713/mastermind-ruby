require "tty-table"
require "pastel"

module Mastermind
  module Board
    class Board
      HEADERS = ["Turn", "Guess Pegs (Code)", "Feedback"].freeze
      MAX_TURNS = 12
      CODE_LENGTH = 4

      def initialize
        @pastel = Pastel.new

        rows = MAX_TURNS.times.map do |turn|
          [(turn + 1).to_s, @pastel.cyan("● ● ● ●"), "○ ○"]
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
