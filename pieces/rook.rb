require_relative 'piece'
require_relative 'movement/slideable'

class Rook < Piece
  include Slideable

  def symbol
    '♜'.colorize(color)
  end

  protected

  def move_directions
    horizontal_directions
  end
end
