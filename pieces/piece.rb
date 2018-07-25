class Piece
  attr_reader :board, :color
  attr_accessor :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos

    raise 'Invalid Color' unless [:white, :black].include?(color)
    raise 'Invalid Position' unless board.valid_pos?(pos)

    board.add_piece(self, pos)
  end

  def to_s
    " #{symbol} "
  end

  def empty?
    if self.is_a?(NullPiece)
      return true
    else
      return false
    end
  end

  def symbol
    # subclass this with unicode character
    raise NotImplementedError
  end

  def valid_moves
    moves.reject { |end_pos| move_into_check?(end_pos) }
  end

  private

  def move_into_check?(end_pos)
    duped_board = board.dup
    duped_board.move_piece!(pos, end_pos)
    duped_board.checked?(color)
  end

end
