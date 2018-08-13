# Western Console Chess

## About

This is a 2-player interactive, pure-ruby chess game runs in the console.  Colors on the tile illuminate the board and also show players where they can move and what pieces are attackable.  

To play, clone this repo, navigate to the project folder and enter <code>ruby game.rb</code>.  

## Demo

<img src="https://media.giphy.com/media/1gWiIQyOre3CPzKYit/giphy.gif" height="400" alt="gameplay-gif">

## Architecture and Technologies

The project is implemented with the following technologies:

- `Ruby` and usage of modules to keep code DRY
- `UTF-8` to display chess pieces
- `Colorize` to display grid colors

## Technical Implementation

Some technical highlights of the app are:
1. Sliding Piece and Stepping Piece Inheritance
2. Deep Board Duplication
3. Cursor Controls

### Sliding Piece and Stepping Piece Inheritance

An instance of Object-Oriented Programming - all pieces inherit from a Piece class.  The Bishop, Rook and Queen inherit from the SlidingPiece module for multi-tile movement, while the Knight and King inherit from the SteppingPiece module.  

### Deep Board Duplication

To check whether a move puts a player in check, the game makes a deep dup of the board with all positions, performs the move and checks the result.  

```ruby
  // from piece.rb

  def move_into_check?(end_pos)
    duped_board = board.dup
    duped_board.move_piece!(pos, end_pos)
    duped_board.checked?(color)
  end
```

```ruby
  // from board.rb

  def dup

    dup_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.color, dup_board, piece.pos)
    end

    dup_board

  end
```

### Cursor Controls

Navigate the game with simple keypad commands.  

```ruby
  // from cursor.rb

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end
```

```ruby
  def handle_key(key)
    case key
    when :ctrl_c
      exit 0
    when :return, :space
      toggle_selected
      cursor_pos
    when :left, :right, :up, :down
      update_pos(MOVES[key])
      nil
    else
      puts key
    end
  end
```

```ruby
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e"
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true
    STDIN.cooked!

    input
  end
```

## Future Features
In the future, I plan to add the following features:

* Board rendering flips when player turn changes
* En Passant
* AI Player
