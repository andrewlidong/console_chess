require_relative 'pieces'
require 'byebug'

class Board
  attr_reader :rows

  def initialize(board_filled = true)
    @sentinel = NullPiece.instance
    populate_board(board_filled)
  end

  # helper methods

  def [](pos)
    if valid_pos?(pos)
      row, col = pos
      @rows[row][col]
    else
      raise 'Invalid position'
    end
  end

  def []=(pos, piece)
    if valid_pos?(pos)
      row, col = pos
      @rows[row][col] = piece
    else
      raise 'Invalid position'
    end
  end

  def pieces
    @rows.flatten.reject(&:empty?)
  end

  def add_piece(piece, pos)
    if empty?(pos)
      self[pos] = piece
    else
      raise 'Position not empty'
    end
  end

  # Piece movement

  def empty?(pos)
    self[pos].empty?
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def move_piece(turn_color, start_pos, end_pos)
    raise 'That position is empty' if empty?(start_pos)

    piece = self[start_pos]
    if piece.color != turn_color
      raise 'Please select your own piece'
    elsif !piece.moves.include?(end_pos)
      raise 'That piece cant move like that'
    elsif !piece.valid_moves.include?(end_pos)
      raise 'That move puts you in check'
    end

    move_piece!(start_pos, end_pos)
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]
    raise 'That piece cant move like that' unless piece.moves.include?(end_pos)

    self[end_pos] = piece
    self[start_pos] = sentinel
    piece.pos = end_pos

    nil
  end


  # checks

  def in_check?(color)
    king_pos = find_king(color).pos
    pieces.any? do |p|
      p.color != color && p.moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    pieces.select { |p| p.color == color }.all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def dup
    new_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.color, new_board, piece.pos)
    end

    new_board
  end


  private

  attr_reader :sentinel

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


    i = color == :white ? 7 : 0

    back_pieces.each_with_index do |piece_class, j|
      piece_class.new(color, self, [i, j])
    end
  end

  def fill_pawns(color)

    i = color == :white ? 6 : 1

    8.times { |j| Pawn.new(color, self, [i, j]) }
  end

  def find_king(color)
    king_pos = pieces.find { |p| p.color == color && p.is_a?(King) }
    king_pos || (raise 'king not found?')
  end

  def populate_board(board_filled)
    @rows = Array.new(8) { Array.new(8, sentinel) }
    return unless board_filled
    %i(white black).each do |color|
      fill_back(color)
      fill_pawns(color)
    end
  end

end
