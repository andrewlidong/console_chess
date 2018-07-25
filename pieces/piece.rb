class Piece
  attr_reader :board, :color
  attr_accessor :pos

  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position

    raise 'invalid color' unless [white,black].include?(color)
    raise 'invalid position' unless board.valid_position?(position)

    board.add_piece(self, position)
  end

  def to_s
    " #{symbol}"
  end

  def empty?
    self.is_a?(NullPiece) ? true : false
  end

  def symbol
    raise NotImplementedError
  end

  def valid_moves
    moves.reject { |end_pos| moves_into_check?(end_pos) }
  end

  private

  def moves_into_check?(end_pos)
    dup_board = board.dup
    dup_board.move_piece!(pos, end_pos)
    dup_board.checked?(color)
  end

end
