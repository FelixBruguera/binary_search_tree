class Node
  attr_accessor :value, :left, :right
  @left = nil
  @right = nil
  @value = nil
  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
end

class Tree < Node
  attr_accessor :array, :root
  @root = nil
  def initialize(array = nil)
    @array = array
  end
  
  def build_tree(array = @array)
    array = array.sort.uniq
    return nil if array.length == 0
    mid_index = (array.length/2.0).floor
    mid_value = array[mid_index]
    if array.length == 1
      root = Node.new(mid_value)
      root.left = nil
      root.right = nil
      return root
    end
    root = Node.new(mid_value)
    if @root == nil then @root = root end
    root.left = build_tree(array[0..mid_index-1])
    root.right = build_tree(array[mid_index+1..-1])
    root
  end
  
  def find(value, position = @root)
    return nil if position.nil?
    return position if position.value == value
    if value > position.value
      find(value, position.right)
    else
      find(value, position.left)
    end
  end
  
  def root
    @root
  end

  def insert(value,position = @root)
    if value > position.value
      if position.right.nil?
        node = Node.new(value)
        return position.right = node
      end
      self.insert(value, position.right)
    else
      if position.left.nil?
        node = Node.new(value)
        return position.left = node
      end
      self.insert(value, position.left)
    end
  end

  def delete(value, position = @root)
    node = self.find(value)
    if node.left != nil && node.right != nil
      right_child = node.right
      left_child = node.left
      parent = nil
      new_node = node.right
      while new_node.left != nil
        new_node = new_node.left
      end
      while parent.nil?
        if position.left.value == value
          position.left = new_node
          parent = position
        elsif position.right.value == value
          position.right = new_node
          parent = position
        else
          position = position.left if value < position.value
          position = position.right if value > position.value
        end
      end
      new_node.left = left_child unless left_child == new_node
      new_node.right = right_child unless right_child == new_node
      right_child.left = nil if right_child.left == new_node
    else
      if node.left != nil then children = node.left
      elsif node.right != nil then children = node.right 
      else children = nil end
      return position.left = children if position.left.value == value
      return position.right = children if position.right.value == value
      if value > position.value then delete(value,position.right)
      else delete(value, position.left) end
    end
  end

  def level_order
    queue = [@root]
    no_block_array = [@root.value]
    until queue.uniq == ["empty"]
      nodes = []
      for i in queue
        if i != nil && i != 'empty'
          if block_given?
            yield(i)
            nodes.push(i.left)
            nodes.push(i.right)
          else
            nodes.push(i.left)
            nodes.push(i.right)
            no_block_array.push(i.left.value) unless i.left.nil?
            no_block_array.push(i.right.value) unless i.right.nil?
          end
        else
          nodes.push('empty')
        end
      end
        queue = nodes
    end
    return no_block_array unless block_given?
  end

  def inorder(position = @root, arr= [], &block)
    return if position.nil?
    arr.push(position.value)
    inorder(position.left, arr, &block)
    yield(position) if block_given?
    inorder(position.right, arr, &block)
    return arr unless block_given?
  end

  def preorder(position = @root, arr= [], &block)
    return if position.nil?
    arr.push(position.value)
    yield(position) if block_given?
    preorder(position.left, arr, &block)
    preorder(position.right, arr, &block)
    return arr unless block_given?
  end

  def postorder(position = @root, arr= [], &block)
    return if position.nil?
    arr.push(position.value)
    postorder(position.left, arr, &block)
    postorder(position.right, arr, &block)
    yield(position) if block_given?
    return arr unless block_given?
  end

  def height(node, count = 0)
    return -1 if node.nil?
    unless node.class == Node
      node = self.find(node) unless node.nil?
    end
    left = height(node.left)
    right = height(node.right)
    left > right ? max = left +1 : max = right +1
    max
  end
  
  def depth(node, position = @root, count= 0)
    unless node.class == Node
      node = self.find(node) unless node.nil?
    end
    return count if position == node
    if node.value > position.value
      depth(node, position.right,count+1)
    else
      depth(node, position.left,count+1)
    end
  end

  def balanced?
    left_tree = self.height(@root.left)
    right_tree = self.height(@root.right)
    difference = left_tree - right_tree
    if difference > 1 || difference < -1
      return false
    end
    true
  end

  def rebalance
    values = self.inorder
    rebalanced_tree = Tree.new
    rebalanced_tree.build_tree(values)
    rebalanced_tree
  end
  
end

# Tests
tree = Tree.new
tree.build_tree((Array.new(15) {rand(0..100)}))
puts "Is the tree balanced?: #{tree.balanced?}"
puts "Level Order"
p tree.level_order {|lev| p lev.value}
puts "-------------------------------------------------"
puts "Pre Order"
p tree.preorder { |elem| puts elem.value}
puts "-------------------------------------------------"
puts "Post Order"
p tree.postorder { |elem| puts elem.value}
puts "-------------------------------------------------"
puts "In Order"
p tree.inorder { |elem| puts elem.value}
puts "-------------------------------------------------"
tree.insert(150)
tree.insert(250)
tree.insert(350)
puts "Is the tree balanced? #{tree.balanced?}"
newtree = tree.rebalance
puts "-------------------------------------------------"
puts "Is the tree balanced? #{newtree.balanced?}"
puts "-------------------------------------------------"
puts "Level Order"
p newtree.level_order {|lev| p lev.value}
puts "-------------------------------------------------"
puts "Pre Order"
p newtree.preorder { |elem| puts elem.value}
puts "-------------------------------------------------"
puts "Post Order"
p newtree.postorder { |elem| puts elem.value}
puts "-------------------------------------------------"
puts "In Order"
p newtree.inorder { |elem| puts elem.value}
