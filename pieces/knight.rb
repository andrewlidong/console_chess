require_relative 'piece'
require_relative 'movement/stepping_piece'

class Knight < Piece
  include SteppingPiece

  def symbol
    '♞'.colorize(color)
  end

  protected

  def move_differences
    [[-2, -1],
     [-1, -2],
     [-2, 1],
     [-1, 2],
     [1, -2],
     [2, -1],
     [1, 2],
     [2, 1]]
  end
end
