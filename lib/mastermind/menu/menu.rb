require_relative "../helpers"
require_relative "./menu_title"
require_relative "./menu_select"

module Mastermind
  module Menu
    class Menu
      include Helpers

      def initialize
        @title = MenuTitle.new
        @select = MenuSelect.new
      end

      def paint
        clear_screen
        @title.paint
        @select.paint
      end

      def choice
        @select.choice
      end
    end
  end
end
