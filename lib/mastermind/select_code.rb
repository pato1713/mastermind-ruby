module Mastermind
  class SelectCode
    attr_reader :choice

    def initialize
      @pastel = Pastel.new
      @prompt = TTY::Prompt.new
      @choice = nil
      @code = []
      @turn = 0
    end

    def code
      while @turn < 4
        @code.push(select)
        @turn += 1
      end

      @code
    end

    def select
      @prompt.select("Select #{@turn + 1} colour: ") do |menu|
        menu.choice @pastel.red("Red"), :red
        menu.choice @pastel.green("Green"), :green
        menu.choice @pastel.yellow("Yellow"), :yellow
        menu.choice @pastel.blue("Blue"), :blue
        menu.choice @pastel.white("White"), :white
        menu.choice @pastel.magenta("Magenta"), :magenta
      end
    end
  end
end
