module SteppingPiece
  def moves
    move_differences.each_with_object([]) do |(dx, dy), moves|
      current_x, current_y = pos
      pos = [current_x + dx, current_y + dy]

      next unless board.valid_pos?(pos)

      if board.empty?(pos)
        moves << pos
      elsif board[pos].color != color
        moves << pos
      end
    end
  end

  private

  def move_differences
    # subclass implements
    raise NotImplementedError
  end
end
