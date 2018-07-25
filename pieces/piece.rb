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
