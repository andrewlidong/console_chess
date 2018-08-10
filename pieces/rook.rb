require_relative 'piece'
require_relative 'movement/sliding_piece'

class Rook < Piece
  include SlidingPiece

  def symbol
    "\xe2\x99\x9c".colorize(color)
    # '♜'.colorize(color)
  end

  protected

  def move_directions
    horizontal_directions
  end
end
