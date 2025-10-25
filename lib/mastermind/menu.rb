require "tty-prompt"
require_relative "./helpers"

module Mastermind
  class Menu
    include Helpers

    attr_reader :choice

    def initialize
      @prompt = TTY::Prompt.new
    end

    def show
      @choice = @prompt.select("What would you like to do?") do |menu|
        menu.choice "Start as Codebreaker", :codebreaker
        menu.choice "Start as Codemaker", :codemaker
        menu.choice "Exit", :exit
      end
    end
  end
end
