require_relative 'piece'

class Pawn < Piece

  def symbol
    '♟'.colorize(color)
  end

  def moves
    forward_steps + side_attacks
  end

  private

  def on_start_row?

    if color == :white
      return pos[0] == 6
    elsif color == :black
      return pos[0] == 1
    end

  end

  def forward_direction
    if color == :white
      return -1
    elsif color == :black
      return 1
    end
  end

  def forward_steps

    i, j = pos

    one_step = [i + 1 * forward_direction, j]

    return [] unless board.valid_pos?(one_step) && board.empty?(one_step)

    steps = [one_step]

    two_step = [i + 2 * forward_direction, j]

    steps << two_step if on_start_row? && board.empty?(two_step)

    steps
  end

  def side_attacks

    i, j = pos

    side_moves = [[i + forward_direction, j - 1], [i + forward_direction, j + 1]]

    side_moves.select do |new_pos|

      next false unless board.valid_pos?(new_pos)
      next false if board.empty?(new_pos)

      threatened_piece = board[new_pos]
      
      threatened_piece && threatened_piece.color != color
    end
  end
end
