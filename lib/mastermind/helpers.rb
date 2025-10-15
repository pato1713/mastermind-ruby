# frozen_string_literal: true

module Mastermind
  module Helpers
    # Module methods (can be called as Mastermind::Helpers.clear_screen)
    def self.clear_screen
      print "\e[2J\e[f"
    end

    # Instance methods (available when included in a class)
    def clear_screen
      Helpers.clear_screen
    end
  end
end
