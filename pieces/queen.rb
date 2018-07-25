require_relative 'piece'
require_relative 'movement/sliding_piece'

class Queen < Piece
  include SlidingPiece

  def symbol
    '♛'.colorize(color)
  end

  protected

  def move_directions
    horizontal_directions + diagonal_directions
  end
end
