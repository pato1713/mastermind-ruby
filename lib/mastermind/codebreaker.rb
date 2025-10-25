require_relative "../mastermind/helpers"
require_relative "../mastermind/guess"
require "pastel"

module Mastermind
  class Codebreaker
    include Helpers

    INITIAL_GUESS = %i[red red blue blue].freeze
    POSSIBLE_CODES = ALLOWED_COLORS.repeated_permutation(4)

    def initialize(secret)
      @pastel = Pastel.new
      @secret = secret
      @current_guess = INITIAL_GUESS
      @unused_codes = POSSIBLE_CODES.to_a
      @feedback = []
    end

    def finished?
      paint_guess
      @current_guess == @secret
    end

    def start
      until finished?
        # Start guessing and remove guess from the unused codes set
        @feedback = normalize_score(Guess.new(@secret).make_guess(@current_guess))
        @unused_codes.delete(@current_guess)

        @unused_codes.filter! do |code|
          feedback = normalize_score(Guess.new(code).make_guess(@current_guess))
          @feedback == feedback
        end

        # find next guess
        @current_guess = next_guess
      end
    end

    private

    def paint_guess
      print "Computer guess is: "
      @current_guess.map { |color| print "#{@pastel.decorate("●", color)} " }
      puts ""
    end

    def normalize_score(score)
      score.sort
    end

    def possible_scores(guess)
      @unused_codes.each_with_object(Hash.new(0)) do |secret_code, obj|
        score = Guess.new(guess).make_guess(secret_code)
        obj[normalize_score(score)] += 1
      end
    end

    def max_possible_score(guess)
      possible_scores(guess).values.max
    end

    def scores
      POSSIBLE_CODES.to_a.each_with_object({}) do |guess, obj|
        obj[guess] = max_possible_score(guess)
      end
    end

    def next_guess
      scrs = scores
      min_val = scrs.values.min
      candidates = scrs.select { |_, v| v == min_val }.keys
      (candidates & @unused_codes).first || candidates.first
    end
  end
end
