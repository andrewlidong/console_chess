require 'colorize'
require_relative 'cursor'

class Display
  attr_reader :board, :notifications, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
    @notifications = {}
  end

  def build_grid
    @board.rows.map_with_index do |row, idx1|
      build_row(row, idx1)
    end
  end

  def build_row
    row.map.map_with_index do |piece, idx2|
      color_options = colors_for(idx1, idx2)
      piece.to_s.colorize(colorize)
    end
  end

  def colors_for(idx1, idx2)
    if cursor.cursor_pos == [idx1, idx2] && cursor.selected
      background = :green
    elsif cursor.cursor_pos == [idx1, idx2]
      background = :light_green
    elsif (idx1 + idx2).odd?
      background = :light_red
    elsif (idx1 + idx2).even?
      background = :light_blue
    end
    { background: background }
  end

  def reset!
    @notifications.delete(:error)
  end

  def remove_check!
    @notifications.delete(:check)
  end

  def set_check!
    @notifications[:check] = "Check"
  end

  def render
    system("clear")
    puts "Please use arrow keys to move, space to enter"
    build_grid.each { |row| puts row.join }

    @notifications.each do |_key, val|
      puts val
    end
  end

end
