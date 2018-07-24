require_relative 'display'
require_relative 'player'

class HumanPlayer < Player
  def make_move(_board)
    start_pos = nil
    end_pos = nil

    until start_pos && end_pos
      display.render

      if start_pos
        puts "It's #{color}'s turn.'"
        end_pos = display.cursor.get_input

        display.reset! if end_pos
      else
        puts "It's #{color}'s turn.'"
        start_pos = display.cursor.get_input

        display.reset! if start_pos
      end
    end

    [start_pos, end_pos]
  end
end
