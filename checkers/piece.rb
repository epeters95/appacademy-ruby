# encoding: UTF-8 

class Piece
  
  SLIDE_DIRS = [[ 1, 1],
                [-1, 1],
                [-1,-1],
                [ 1,-1]]
                
  JUMP_DIRS  = [[ 2, 2],
                [-2, 2],
                [-2,-2],
                [ 2,-2]]
                
  attr_accessor :color, :pos, :king
  
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @king = false
    @board.add_piece(self, @pos.dup)
  end
  
  def valid_dirs
    all_dirs = correct(SLIDE_DIRS) + correct(JUMP_DIRS)
    all_dirs.select do |dir|
      new_pos = @pos.plus(dir)
      new_pos.on_board? && @board.get_piece(new_pos).nil?
    end
  end
  
  def perform_slide(direction)
    return false unless SLIDE_DIRS.include?(direction)
    if valid_dirs.include?(direction)
      move(direction)
    else
      false
    end
  end
  
  def perform_jump(direction)
    return false unless JUMP_DIRS.include?(direction)
    
    if valid_dirs.include?(direction)
      truncated_dir = SLIDE_DIRS[JUMP_DIRS.index(direction)]
      adj_piece = @board.get_piece(@pos.plus(truncated_dir))
      return false if adj_piece.nil?
      if adj_piece.color != @color
        @board.remove_piece(adj_piece.pos)
        
        move(direction)
      else
        false
      end
    else
      false
    end
  end
  
  def perform_moves!(move_seq)
    slides = move_seq.select { |dir| SLIDE_DIRS.include?(dir) }
    if move_seq.length > 1 && slides.length > 0
      raise InvalidMoveError.new("Move sequence is faulty")
    else
      move_seq.each do |dir|
        if SLIDE_DIRS.include?(dir)
          perform_slide(dir)
          next
        elsif JUMP_DIRS.include?(dir)
          perform_jump(dir)
          next
        end
        raise InvalidMoveError.new("Move failed")
      end
    end
  end
  
  def valid_move_seq?(move_seq)
    new_board = @board.dup
    begin
      new_board.get_piece(@pos).perform_moves!(move_seq)
    rescue InvalidMoveError => e
      return false
    else
      return true
    end
  end
  
  def perform_moves(move_seq)
    if valid_move_seq?(move_seq)
      perform_moves!(move_seq)
    else
      raise InvalidMoveError.new("Error in perfom_moves")
    end
  end
  
  def dup(board)
    new_piece = Piece.new(board, @pos.dup, color)
    new_piece.king = @king
  end        
  
  def move(direction)
    old_pos = @pos.dup
    @pos = @pos.plus(direction)
    if @color == :black
      @king = true if @pos[1] == 7
    else
      @king = true if @pos[1] == 0
    end
    @board.add_piece(self, @pos)
    @board.remove_piece(old_pos)
  end
  
  def correct(dir)
    return (@color == :black ? dir.take(2) : dir.drop(2)) unless @king
    dir
  end
  
  def inspect
    if @color == :white
      return 'k' if @king
			# return '♚' if @king
			return '0' if !@king   
      #return '◉' if !@king
    else
			return 'K' if @king
      #return '♔' if @king
			return 'O' if !@king
      #return '◎' if !@king
    end
  end
  
  def slides
    SLIDE_DIRS
  end
  
  def jumps
    JUMP_DIRS
  end
  
end

class Array
  
  def plus(arr)
    raise "Invalid array sum" if length != arr.length
    sum = self.dup
    arr.each_with_index { |el, i| sum[i] += el }
    sum
  end
  
  def minus(arr)
    raise "Invalid array difference" if length != arr.length
    dif = self.dup
    arr.each_with_index { |el, i| dif[i] -= el }
    dif
  end
  
  def on_board?
    length == select { |el| el.between?(0,7) }.length
  end
end

class InvalidMoveError < StandardError
end