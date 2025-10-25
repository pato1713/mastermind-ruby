# frozen_string_literal: true

module Mastermind
  module Helpers
    ALLOWED_COLORS = %i[red blue yellow green white magenta].freeze

    def clear_screen
      print "\e[2J\e[f"
    end
  end
end
