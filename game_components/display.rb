require "colorize"
require_relative "cursor"
require "byebug"

class Display

  attr_reader :board, :cursor, :notifications

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
    @notifications = {}
  end

  def build_board
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if cursor.cursor_pos == [i, j] && cursor.selected
      background = :green
    elsif cursor.cursor_pos == [i, j]
      background = :light_green
    elsif (i + j).odd?
      background = :light_red
    elsif (i + j).even?
      background = :yellow
    end
    { background: background }
  end

  def reset_notifications!
    @notifications.delete(:error)
  end

  def remove_check!
    @notifications.delete(:check)
  end

  def add_check!
    @notifications[:check] = "Check!"
  end

  def render
    system("clear")

    puts "Welcome to Western Console Chess."
    puts "Use arrow keys or WASD to move the cursor."
    puts "Hit the spacebar or enter to confirm a selection."
    puts "\n"

    build_board.each { |row| puts row.join }

    @notifications.each do |_key, val|
      puts val
    end
  end

end
