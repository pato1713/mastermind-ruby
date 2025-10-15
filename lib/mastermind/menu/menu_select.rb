# frozen_string_literal: true

require "tty-prompt"
require "pastel"

module Mastermind
  module Menu
    class MenuSelect
      attr_reader :prompt, :choice

      def initialize
        @prompt = TTY::Prompt.new
        @choice = nil
      end

      def paint
        @choice = prompt.select("What would you like to do?") do |menu|
          menu.choice "Start the game", :start
          menu.choice "Exit", :exit
        end
      end
    end
  end
end
