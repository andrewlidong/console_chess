require_relative 'piece'
require_relative 'movement/sliding_piece'

class Bishop < Piece
  include SlidingPiece

  def symbol
    "\xe2\x99\x9d".colorize(color)
    # '♝'.colorize(color)
  end

  protected

  def move_directions
    diagonal_directions
  end
end
