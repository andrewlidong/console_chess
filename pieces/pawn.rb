require_relative 'piece'

class Pawn < Piece

  def symbol
    '♟'.colorize(color)
  end

  def moves
    forward_steps + side_attacks
  end

  private

  def at_start_row?
    position[0] == (color == :white) ? 6 : 1
  end

  def forward_direction
    color == :white ? -1 : 1
  end

  def forward_steps
    i, j = position

    one_step = [i + forward_direction, j]

    return [] unless board.valid_position?(one_step) && board.empty?(one_step)

    steps = [one_step]

    two_step = [i + 2 * forward_direction, j]

    steps << two_step if at_start_row? && board.empty?(two_step)

    steps
  end

  def side_attacks
    i, j = position

    side_moves = [[i + forward_direction, j - 1], [i + forward_direction, j + 1]]

    side_moves.select do |new_position|
      next false unless board.valid_position?(new_position)
      next false if board.empty?(new_position)

      opponent_piece = board[new_position]
      opponent_piece && opponent_piece.color != color
    end
  end
end
