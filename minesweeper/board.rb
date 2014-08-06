require './tile'

class Board
  attr_reader :tiles, :size_x, :size_y
  def initialize(size_x, size_y, num_bombs)
    @num_bombs = num_bombs
    @cursor_pos = [size_x/2, size_y/2]
    @size_x = size_x
    @size_y = size_y
    create_tiles
    create_bombs
    tile(@cursor_pos).selected = true
  end
  
  def create_tiles
    @tiles = []
    (0...@size_y).each do |y|
      new_row = []
      (0...@size_x).each do |x|
        new_row << Tile.new(self,[x,y])
      end
      @tiles << new_row
    end
  end
  
  def create_bombs
    while @num_bombs != 0 
      x = rand(0...@size_x)
      y = rand(0...@size_y)
      if !tile([x,y]).bomb
        tile([x,y]).bomb = true
        @num_bombs -= 1
      end
    end
  end
  
  def move_cursor(new_pos)
    tile(@cursor_pos).selected = false
    @cursor_pos[0] = (@cursor_pos[0] + new_pos[0]) % @size_x
    @cursor_pos[1] = (@cursor_pos[1] + new_pos[1]) % @size_y
    tile(@cursor_pos).selected = true
  end
  
  def tile(position)
    @tiles[position[1]][position[0]]
  end
  
  def choose_reveal(position)
    if tile(position).flag
      return "This tile is already flagged."
    else
      tile(position).reveal
      return "#{position.join(', ')} cleared."
    end
  end
  
  def reveal_all
    @tiles.each do |y|
      y.each do |tile|
        tile.revealed = true
      end
    end
  end
  
  def choose_flag(position)
    if tile(position).flag == true
      tile(position).flag = false
      "Removed flag at #{position.join(', ')}."
    else
      tile(position).flag = true
      "#{position.join(', ')} flagged."
    end
  end
  
  def display
    puts "\e[H\e[2J"
    (0...@size_y).each do |y|
      (0...@size_x).each do |x|
        tile([x, y]).inspect
      end
      print "\n"
    end
  end
  
  def select_move(input, prev)
    position = @cursor_pos
    case input.downcase
    when 'w'
      move_cursor([0, -1])
      prev
    when 'a'
      move_cursor([-1, 0])
      prev
    when 's'
      move_cursor([0, 1])
      prev
    when 'd'
      move_cursor([1, 0])
      prev
    when '/'
      choose_flag(position)
    when ' '
      if tile(position).bomb
        reveal_all
        display
        puts "\nYou lose! :(\n\n"
        "You lose!"
      else
        choose_reveal(position)
      end
    when 'v'
      "Game saved."
    when 'l'
      "Game loaded."
    when 'q'
      "Goodbye"
    else
      "Invalid input."
    end
  end
end