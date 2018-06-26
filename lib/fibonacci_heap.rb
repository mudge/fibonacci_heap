require 'circular_doubly_linked_list'

class FibonacciHeap
  InvalidKeyError = Class.new(StandardError)

  class Node < CircularDoublyLinkedList::Node
    attr_accessor :degree, :p, :mark, :children

    def initialize(*args)
      super

      @children = CircularDoublyLinkedList.new
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
    x.mark = false

    if !min
      self.root_list = CircularDoublyLinkedList.new

      root_list.insert(x)

      self.min = x
    else
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
      z.children.each do |x|
        root_list.insert(x)
        x.p = nil
      end
      root_list.delete(z)
      if z == z.right
        self.min = nil
        self.root_list = CircularDoublyLinkedList.new
      else
        self.min = z.right
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
    degrees = {}

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

    self.min = nil
    self.root_list = CircularDoublyLinkedList.new

    degrees.each do |degree, root|
      next unless root

      if !min
        self.root_list = CircularDoublyLinkedList.new
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
    root_list.delete(y)
    x.children.insert(y)
    x.degree += 1
    y.p = x
    y.mark = false
  end

  def cut(x, y)
    y.children.delete(x)
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

