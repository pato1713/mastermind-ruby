# frozen_string_literal: true

require "mastermind/codebreaker"
require "mastermind/menu"
require "mastermind/guess"
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

      if @menu.choice == :codebreaker
        codebreaker_main_loop
      elsif @menu.choice == :codemaker
        codemaker_main_loop
      end
    end

    private

    def codemaker_main_loop
      @title.show
      user_secret = SelectCode.new.code
      Codebreaker.new(user_secret).start
    end

    def codebreaker_main_loop
      until finished?
        Board.new(@game_data).show
        guess
        clear_screen
      end
    end

    def guess
      user_guess = SelectCode.new.code
      feedback = Guess.new(@secret).make_guess(user_guess)
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

      return false unless @game_data.length == MAX_ROUNDS

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
