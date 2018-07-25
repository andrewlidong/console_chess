module SlidingPiece
  HORIZONTAL_DIRECTIONS = [
    [-1, 0],
    [0, -1],
    [0, 1],
    [1, 0]
  ].freeze

  DIAGONAL_DIRECTIONS = [
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1]
  ].freeze

  def horizontal_directions
    HORIZONTAL_DIRECTIONS
  end

  def diagonal_directions
    DIAGONAL_DIRECTIONS
  end

  def moves
    moves = []

    move_directions.each do |dx, dy|
      moves.concat(grow_unblocked_moves_in_dir(dx, dy))
    end

    moves
  end

  private

  def move_directions
    # subclass implements
    raise NotImplementedError
  end

  def grow_unblocked_moves_in_dir(dx, dy)

    current_x, current_y = pos
    moves = []

    loop do
      current_x, current_y = current_x + dx, current_y + dy
      pos = [current_x, current_y]

      break unless board.valid_pos?(pos)

      if board.empty?(pos)
        moves << pos
      else
        # capture an opponent
        moves << pos if board[pos].color != color

        # can't move past blocker
        break
      end
    end
    moves
  end
end
