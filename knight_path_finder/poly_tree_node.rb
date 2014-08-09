module Searchable

  # Depth-first search for nodes
  def dfs(value)
    return self if self.value == value
    return nil if self.children == []
    self.children.first.dfs(value) || self.children.last.dfs(value)
  end
  
  # Breadth-first search
  def bfs(value)
    queue = [self]
    until queue.length == 0
      first = queue.shift
      return first if first.value == value
      first.children.each do |child|
        queue << child
      end
    end
  end  
end

class PolyTreeNode
  include Searchable

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end
  
  def parent=(parent)
    @parent.children.delete(self) if !@parent.nil?
    
    if parent
      @parent = parent
      @parent.children << self
    else
      @parent = nil
    end
  end
  
  def parent
    @parent
  end
  
  def children
    @children
  end
  
  def value
    @value
  end
  
  def add_child(child_node)
    child_node.parent = self
  end
  
  def remove_child(child)
    child.parent = nil
    @children.delete(child)
  end
  
  def trace_path_back
    node = self
    path = []
    until node.parent.nil?
      path << node.parent.value
      node = node.parent
    end
    path.reverse
    path.unshift(self.value)
    
  end
end



















