require_relative './game_components/board'
require_relative './game_components/human_player'

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
        start_pos, end_pos = players[current_player].play_move(board)

        board.move_piece(current_player, start_pos, end_pos)

        end_turn!

        notify_players

      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end

    end

    display.render

    puts "#{current_player} has lost."

    nil
  end

  private

  def notify_players

    if board.checked?(current_player)
      display.add_check!
    else
      display.remove_check!
    end

  end

  def end_turn!
    @current_player = current_player == :white ? :black : :white
  end
end

if $PROGRAM_NAME == __FILE__
  Game.new.play
end
