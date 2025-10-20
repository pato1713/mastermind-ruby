# frozen_string_literal: true

require "mastermind/menu"
require "mastermind/title"
require "mastermind/board"
require "mastermind/helpers"
require "mastermind/select_code"
require "tty-font"
require "pastel"

module Mastermind
  # Main Game Class
  class Game
    include Helpers

    ALLOWED_COLORS = %i[red blue yellow green white magenta].freeze
    CODE_LENGTH = 4
    MAX_ROUNDS = 12

    def initialize
      @title = Title.new
      @menu = Menu.new
      @secret = generate_secret
      @game_data = []
    end

    def start
      @title.show
      @menu.show
      return if @menu.choice == :exit

      clear_screen
      main_loop
    end

    private

    def main_loop
      until finished?
        Board.new(@game_data).show
        guess
        clear_screen
      end
    end

    def guess
      user_guess = SelectCode.new.code
      feedback = []
      guess_unmatched = []
      secret_unmatched = []

      # Find exact matches
      user_guess.zip(@secret).each do |g, s|
        if g == s
          feedback.push(:red)
        else
          guess_unmatched.push(g)
          secret_unmatched.push(s)
        end
      end

      # Find other matches
      guess_unmatched.each do |g|
        if secret_unmatched.include?(g)
          feedback.push(:white)
          secret_unmatched.delete_at(secret_unmatched.index(g))
        end
      end

      @game_data.push({
                        code: user_guess,
                        feedback: feedback
                      })
    end

    def generate_secret
      CODE_LENGTH.times.map { ALLOWED_COLORS.sample }
    end

    def finished?
      @title.show
      return false if @game_data.empty?

      if @secret == @game_data.last[:code]
        show_win_info
        return true
      end

      return unless @game_data.length == MAX_ROUNDS

      show_lost_info
      true
    end

    def show_lost_info
      puts Pastel.new.red(TTY::Font.new.write("You've lost!"))
    end

    def show_win_info
      puts Pastel.new.green(TTY::Font.new.write("You've won!"))
    end
  end
end
