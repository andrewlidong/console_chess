require_relative 'board'
require_relative 'human_player'

class Game
  attr_reader :board, :display, :current_player, :players

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = {
      white: HumanPlayer.new(:white, @display),
      black: HumanPlayer.new(:black, @display)
    }
    @current_player = :white
  end

  def play
    until board.checkmate?(current_player)
      begin
        start_pos, end_pos = players[current_player].make_move(board)
        board.move_piece(current_player, start_pos, end_pos)

        next_turn!
        notify_checked
      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end
    end

    display.render
    puts "#{current_player} has been mated"

    nil
  end

  private

  def notify_checked
    if board.checked?(current_player)
      display.set_check!
    else
      display.remove_check!
    end
  end

  def next_turn!
    @current_player = current_player == :white ? :black : :white
  end
end

if $PROGRAM_NAME == __FILE__
  Game.new.play
end
