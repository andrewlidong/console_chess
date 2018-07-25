require_relative 'piece'
require_relative 'slideable'

class Queen < Piece
  include Slideable

  def symbol
    '♛'.colorize(color)
  end

  protected

  def move_directions
    horizontal_directions + diagonal_directions
  end
end
