module Slideable
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
      moves.concat(grow_unblocked_moves_in_direction(dx, dy))
    end

    moves
  end

  private

  def move_directions
    raise NotImplementedError
  end

  def grow_unblocked_moves_in_direction(dx, dy)
    current_x, current_y = position
    moves = []

    loop do
      current_x = current_x + dx
      current_y = current_y + dy

      position = [current_x, current_y]

      break unless board.valid_position?(position)

      if board.empty?(position)
        moves << position
      else
        moves << position if board[position].color != color
        break
      end
    end

    moves
  end
end
