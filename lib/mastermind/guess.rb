module Mastermind
  class Guess
    def initialize(secret)
      @guess = nil
      @secret = secret
      @feedback = []
      @guess_unmatched = []
      @secret_unmatched = []
    end

    def make_guess(input)
      @guess = input

      find_exact_matches
      find_other_matches

      @feedback
    end

    private

    def find_exact_matches
      @guess.zip(@secret).each do |g, s|
        if g == s
          @feedback.push(:red)
        else
          @guess_unmatched.push(g)
          @secret_unmatched.push(s)
        end
      end
    end

    def find_other_matches
      @guess_unmatched.each do |g|
        if @secret_unmatched.include?(g)
          @feedback.push(:white)
          @secret_unmatched.delete_at(@secret_unmatched.index(g))
        end
      end
    end
  end
end
