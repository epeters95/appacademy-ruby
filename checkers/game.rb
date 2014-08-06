require 'io/console'
require './board'

class Game
  
  def initialize
    @game_board = Board.new
    @cursor_pos = [3,3]
    @turn = :white
    @move_seq = []
    
    @over = false
    play_game
  end
  
  def play_game
    @game_board.setup
    @game_board.display(@cursor_pos)
    msg = "White's turn - select a piece"
    until win?(:white) || win?(:black) || @over
      system("clear")
      puts msg
      @game_board.display(@cursor_pos)
      msg = handle(STDIN.getch, msg)
    end
    puts "White wins!" if win?(:white)
    puts "Black wins!" if win?(:black)
  end
  
  def handle(input, prev_msg)
    case input.downcase
    when 'w'
      move_cursor([ 0,-1])
      prev_msg
    when 's'
      move_cursor([ 0, 1])
      prev_msg
    when 'a'
      move_cursor([-1, 0])
      prev_msg
    when 'd'
      move_cursor([ 1, 0])
      prev_msg
    when ' '
      move_piece(@cursor_pos) || prev_msg
    when 'f'
      next_turn
    when 'q'
      @over = true
    end
  end
  
  def whos_turn
    (@turn == :white ? "White's turn" : "Black's turn")
  end
  
  def move_cursor(direction)
    new_pos = @cursor_pos.plus(direction)
    @cursor_pos = new_pos if new_pos.on_board?
  end
  
  def move_piece(select_pos)
    msg = nil
    if @move_seq.empty?
      selection = @game_board.get_piece(select_pos)
      unless selection.nil?
        return "Wrong color" if selection.color != @turn
        @move_seq << select_pos
        msg = "#{whos_turn} - select a move sequence (press F when finished)"
      end
    else
      start_pos = @move_seq.first
      (1...@move_seq.length).each do |i|
        start_pos = start_pos.plus(@move_seq[i])
      end
      @move_seq << select_pos.minus(start_pos)
    end
    msg
  end
  
  def next_turn
    unless @move_seq.empty?
      start_piece = @game_board.get_piece(@move_seq.first)
      begin
        start_piece.perform_moves(@move_seq.drop(1))
      rescue InvalidMoveError => e
        msg = "Invalid move!"
      else
        (@turn == :black ? @turn = :white : @turn = :black)
        msg = "#{whos_turn} - select a piece"
      end
      @move_seq = []
      msg
    end
  end
  
  def win?(color)
    @game_board.grid.flatten.select { |piece| !piece.nil? && piece.color != color }.empty?
  end
  
end



Game.new









