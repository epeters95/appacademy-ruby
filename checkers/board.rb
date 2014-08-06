# encoding: UTF-8 
require './piece'

class Board
  
  attr_accessor :display
  attr_reader :grid
  
  def initialize
    @grid = Array.new (8) { Array.new (8) {nil} }
  end
  
  def get_piece(pos_arr)
    @grid[pos_arr[1]][pos_arr[0]]
  end
  
  def add_piece(piece, pos_arr)
    @grid[pos_arr[1]][pos_arr[0]] = piece
  end
  
  def remove_piece(pos_arr)
    @grid[pos_arr[1]][pos_arr[0]] = nil
  end
  
  def setup
    (0...3).each do |y|
      (0...8).each do |x|
        Piece.new(self, [x, y], :black ) if (x + y).odd?
      end
    end
    (5...8).each do |y|
      (0...8).each do |x|
        Piece.new(self, [x, y], :white) if (x + y).odd?
      end
    end
  end
  
  def display(cursor_pos)
    @grid.each_with_index do |row, y|
      row.each_with_index do |piece, x|
        if piece.nil?
          ch = "░ " if (x + y).even?
          ch = "_ " if (x + y).odd?
        else
          ch = piece.inspect + " "
        end
				ch = '▓ ' if [x,y] == cursor_pos
				# ch = ch.green if [x,y] == cursor_pos
        print ch
      end
      puts
    end
  end
  
  def dup
    new_board = Board.new
    (0...8).each do |y|
      (0...8).each do |x|
        piece = self.get_piece([x,y])
        piece.dup(new_board) unless piece.nil?
      end
    end
    new_board
  end
  
end


class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end


=begin
b = Board.new
b.get_piece([2,5]).perform_slide([1,-1])
b.display
b.get_piece([3,4]).perform_slide([1,-1])
b.display
b.get_piece([1,2]).perform_slide([-1,1])
b.display
b.get_piece([2,1]).perform_slide([-1,1])
b.display
b.get_piece([4,3]).perform_jump([-1,-1])
b.display
b.get_piece([0,3]).perform_slide([1,1])
b.get_piece([1,4]).perform_slide([1,1])
b.get_piece([4,1]).perform_slide([-1,1])
b.display
=end