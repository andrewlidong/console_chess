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
    @rows.flatten.reject{ |pos| pos.empty?}
    # (&:empty?)
  end

  def add_piece(piece, pos)
    if empty?(pos)
      self[pos] = piece
    else
      raise 'Position is occupied'
    end
  end

  # Piece movement

  def empty?(pos)
    self[pos].empty?
  end

  def valid_pos?(pos)
    pos.all? { |coordinates| coordinates.between?(0, 7) }
  end

  def move_piece(turn_color, start_pos, end_pos)

    if empty?(start_pos)
      raise 'That position is empty'
    else
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

  end

  def move_piece!(start_pos, end_pos)

    piece = self[start_pos]

    if piece.moves.include?(end_pos)
      self[end_pos] = piece
      self[start_pos] = sentinel
      piece.pos = end_pos

      return nil
    else
      raise 'That piece cant move like that'
    end

  end

  # checks

  def checked?(color)

    king_pos = find_king(color).pos

    pieces.any? do |piece|
      piece.color != color && piece.moves.include?(king_pos)
    end

  end

  def checkmate?(color)

    if checked?(color)
      pieces.select { |piece| piece.color == color }.all? do |piece|
        piece.valid_moves.empty?
      end
    else
      return false unless checked?(color)
    end

  end

  def dup

    dup_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.color, dup_board, piece.pos)
    end

    dup_board

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


    if color == :white
      i = 7
    else
      i = 0
    end

    back_pieces.each_with_index do |piece_class, j|
      piece_class.new(color, self, [i, j])
    end

  end

  def fill_pawns(color)

    if color == :white
      i = 6
    else
      i = 1
    end

    8.times { |j| Pawn.new(color, self, [i, j]) }
  end

  def find_king(color)

    king_pos = pieces.find { |piece| piece.color == color && piece.is_a?(King) }

    king_pos || (raise 'King is Missing')

  end

  def populate_board(board_filled)

    @rows = Array.new(8) { Array.new(8, sentinel) }

    return unless board_filled
    [:white, :black].each do |color|
      fill_back(color)
      fill_pawns(color)
    end
  end

end
