module Stepable
  def moves
    move_differences.each_with_object([]) do |(dx, dy), moves|
      current_x, current_y = position
      position = [current_x + dx, current_y + dy]

      next unless board.valid_position?(position)

      if board.empty?(position)
        moves << position
      elsif board[position].color != color
        moves << position
      end
    end
  end

  private

  def move_differences
    raise NotImplementedError
  end

end
