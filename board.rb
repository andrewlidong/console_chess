require_relative 'pieces'

class Board
  attr_reader :rows

  def initialize(board_filled = true)
    @sentinel = NullPiece.instance
    make_starting_grid(board_filled)
  end

  def [](pos)
    raise 'invalid position' unless valid_position?(pos)

    row, col = pos
    @rows[row][col]
  end

  def []=(pos, piece)
    raise 'invalid position' unless valid_position?(pos)

    row, col = pos
    @rows[row][col] = piece
  end

  def valid_position?(pos)
    pos.all? { |coordinate| coordinate.between?(0,7) }
  end

  def empty?(pos)
    self[pos].empty?
  end

  def add_piece(piece, pos)
    raise 'position is occupied' unless empty?(pos)

    self[pos] = piece
  end

  def pieces
    @rows.flatten.reject(&:empty?)
  end

  def move_piece(turn_color, start_pos, end_pos)
    raise 'starting position is empty' if empty?(start_pos)

    piece = self[start_pos]
    if piece.color != turn_color
      raise 'This is not your piece'
    elsif !piece.moves.include?(end_pos)
      raise 'Invalid move'
    elsif !piece.valid_moves.include?(end_pos)
      raise 'Move puts you in check'
    end_pos

    move_piece!(start_pos, end_pos)
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]
    raise 'Invalid move' unless piece.moves.include?(end_pos)

    self[end_pos] = piece
    self[start_pos] = sentinel
    piece.pos = end_pos

    return nil
  end

  def checked?(color)
    king_pos = find_king(color).pos
    pieces.any? { |piece| piece.color != color && piece.moves.include?(king_pos)}
  end

  def checkmate?(color)
    return false unless checked?(color)

    pieces.select { |piece| piece.color == color }.all? do |defender|
      defender.valid_moves.empty?
    end
  end

  def dup
    new_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.color, new_board, piece.pos)
    end
  end


  private

  attr_reader :sentinel

  def fill_pawns(color)
    if color == :white
      row = 6
    else
      row = 1
    end

    8.times do |col|
      Pawn.new(color, self, [row,col])
    end
  end

  def fill_back(color)
    back_pieces = [
      Rook,
      Knight,
      Bishop,
      Queen,
      King,
      Bishop,
      Knight,
      Rook
    ]

    if color == :white
      row = 7
    else
      row = 0
    end

    back_pieces.each_with_index do |piece_class, col|
      piece_class.new(color, self, [row, col])
    end
  end

  def find_king(color)
    king_position = pieces.find { |piece| piece.color == color && piece.is_a?(King)}
    return king_position || (raise 'king not found')
  end

  def make_starting_grid(board_filled)
    @rows = Array.new(8) { Array.new(8, sentinel) }
    return unless board_filled
    [white, black].each do |color|
      fill_back(color)
      fill_pawns(color)
    end
  end

end
