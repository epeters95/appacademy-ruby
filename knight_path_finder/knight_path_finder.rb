require './poly_tree_node'

# This class is used to find moves for a Knight in chess
#
# Given a starting position on the board, there are methods
# for showing all possible moves, or showing a sequence of
# moves to reach any other point on the board.
class KnightPathFinder
  attr_accessor :visited_positions
  
  def initialize(start_pos)
    @position = start_pos
    @visited_positions = [start_pos]
  end
  
  def self.valid_moves(pos)
    valid_moves = []
    move_one = [1, -1]
    move_two = [2, -2]
    
    coords = []
    
    coords << [pos[0] + move_one[0], pos[1] + move_two[0]]
    coords << [pos[0] + move_one[1], pos[1] + move_two[1]]
    coords << [pos[0] + move_one[1], pos[1] + move_two[0]]
    coords << [pos[0] + move_one[0], pos[1] + move_two[1]]
    
    coords << [pos[0] + move_two[0], pos[1] + move_one[0]]
    coords << [pos[0] + move_two[1], pos[1] + move_one[1]]
    coords << [pos[0] + move_two[1], pos[1] + move_one[0]]
    coords << [pos[0] + move_two[0], pos[1] + move_one[1]]
    
    coords.each do |pair|
      if pair[0].between?(0,7) && pair[1].between?(0,7)
        valid_moves << pair
      end
    end
    valid_moves
  end
  
  def new_move_positions(pos)
    possible_moves = KnightPathFinder.valid_moves(pos)
    delete_moves = []
    possible_moves.each do | move |
      if @visited_positions.include?(move)
        delete_moves << move
      else
        @visited_positions << move
      end
    end
    delete_moves.each do |move|
      possible_moves.delete(move)
    end
    possible_moves
  end
  
  def build_move_tree
    root = PolyTreeNode.new(@position)
    queue = [root]
    
    until queue == []
      first = queue.shift
      new_move_positions(first.value).each do |pos| 
        first.add_child(PolyTreeNode.new(pos)) 
      end
      first.children.each do |child|
        queue << child
      end
    end
    root
  end
  
  def find_path(end_pos)
    # Breadth-first preferred to skip over infinitely long branches of moves
    build_move_tree.bfs(end_pos).trace_path_back    
  end  
end