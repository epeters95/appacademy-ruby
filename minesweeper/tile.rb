require 'yaml'
require 'io/console'

class Tile
  attr_reader :position
  attr_accessor :bomb, :flag, :revealed, :selected
  
  def initialize(board, position)    
    @board = board
    @position = position
    @bomb = false
    @flag = false
    @revealed = false
    @selected = false
  end
  
  def neighbors
    output = []
    y_self = @position[1]
    x_self = @position[0]
    (-1..1).each do |y|
      (-1..1).each do |x|
        next if x == 0 && y == 0
        new_y = (y_self + y)
        new_x = (x_self + x)
        if new_y.between?(0,@board.size_y-1) && new_x.between?(0,@board.size_x-1)
          new_neighbor = @board.tile([new_x, new_y])
          output << new_neighbor
        end
      end
    end
    output
  end
  
  def bomb_count
    neighbors.select { |x| x.bomb }.length
  end
  
  def reveal
    @revealed = true
    neighbors.each do |neighbor|
      neighbor.reveal if bomb_count == 0 && !neighbor.revealed && !neighbor.flag
    end
  end
  
  def inspect
    if @selected
      if @bomb && @revealed
        print '* '
      else
        print "\u2592".encode('utf-8') + ' '
      end
    elsif !@revealed
      print "\u2591".encode('utf-8') + ' ' unless @flag
      print '/ ' if @flag
    else
      if @bomb
        print '* '
      else
        print bomb_count.to_s + ' ' if bomb_count > 0
        print '_ ' if bomb_count == 0
      end
    end
  end
end