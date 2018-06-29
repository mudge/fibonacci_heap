require 'circular_doubly_linked_list'

class FibonacciHeap
  InvalidKeyError = Class.new(StandardError)

  class Node < CircularDoublyLinkedList::Node
    attr_accessor :degree, :p, :mark, :child_list

    def initialize(*args)
      super

      @child_list = CircularDoublyLinkedList.new
    end

    def inspect
      "#<Node key:#{key} p:#{p} child:#{child_list.first}>"
    end
  end

  attr_accessor :n, :min, :root_list

  def initialize
    @n = 0
    @min = nil
  end

  def insert(x)
    x.degree = 0
    x.p = nil
    x.child_list = CircularDoublyLinkedList.new
    x.mark = false

    if !min
      # Create a root list for H containing just x
      self.root_list = CircularDoublyLinkedList.new
      root_list.insert(x)

      self.min = x
    else
      # Insert x into H's root list
      root_list.insert(x)

      if x.key < min.key
        self.min = x
      end
    end

    self.n += 1
  end

  def pop
    z = min

    if z
      # For each child x of z
      z.child_list.each do |x|

        # Add x to the root list of H
        root_list.insert(x)
        x.p = nil
      end

      # Remove z from the root list of H
      root_list.delete(z)

      # Is z the only node on the root list?
      if z.right == z.left
        # Empty the heap
        self.min = nil
        self.root_list = CircularDoublyLinkedList.new
      else
        if z.right != root_list.sentinel
          self.min = z.right
        elsif z.left != root_list.sentinel
          self.min = z.left
        else
          fail 'z has no real node next to it?'
        end

        consolidate
      end

      self.n -= 1
    end

    z
  end

  def decrease_key(x, k)
    fail InvalidKeyError, 'new key is greater than current key' if k > x.key

    x.key = k
    y = x.p

    if y && x.key < y.key
      cut(x, y)
      cascading_cut(y)
    end

    if x.key < min.key
      self.min = x
    end
  end

  def delete(x)
    decrease_key(x, -Float::INFINITY)
    pop
  end

  private

  def consolidate
    degrees = []

    root_list.each do |w|
      x = w
      d = x.degree

      while degrees[d]
        y = degrees[d]

        if x.key > y.key
          x, y = y, x
        end

        link(y, x)

        degrees[d] = nil

        d += 1
      end

      degrees[d] = x
    end

    # Empty the root list
    self.min = nil
    self.root_list = CircularDoublyLinkedList.new

    # Reconstruct the root list from the array A
    degrees.each do |root|
      next unless root

      if !min
        root_list.insert(root)
        self.min = root
      else
        root_list.insert(root)
        if root.key < min.key
          self.min = root
        end
      end
    end
  end

  def link(y, x)
    # remove y from the root list of H
    root_list.delete(y)
    # make y a child of x, incrementing x.degree
    x.child_list.insert(y)
    x.degree += 1
    y.p = x
    y.mark = false
  end

  def cut(x, y)
    y.child_list.delete(x)
    y.degree -= 1
    root_list.insert(x)
    x.p = nil
    x.mark = false
  end

  def cascading_cut(y)
    z = y.p
    if z
      if !y.mark
        y.mark = true
      else
        cut(y, z)
        cascading_cut(z)
      end
    end
  end
end

