require_relative 'piece'
require_relative 'slideable'

class Bishop < Piece
  include Slideable

  def symbol
    '♝'.colorize(color)
  end

  protected

  def move_directions
    diagonal_directions
  end
end
