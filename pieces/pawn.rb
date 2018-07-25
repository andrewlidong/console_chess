class Pawn < Piece

  def symbol
    '♟'.colorize(color)
  end

  def moves
    forward_steps + side_attacks
  end

  private

end
