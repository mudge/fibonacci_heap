require 'circular_doubly_linked_list'

# A Fibonacci Heap data structure.
#
# A "mergeable heap" that supports several operations that run in
# constant amortized time. Structured as a collection of rooted trees
# that are min-heap ordered.
class FibonacciHeap
  InvalidKeyError = Class.new(StandardError)

  # A single node in a rooted tree.
  #
  # Contains a key and an optional value (which defaults to the key),
  # the former of which will be used to sort nodes so that the key
  # of a node is greater than or equal to the key of its parent.
  class Node < CircularDoublyLinkedList::Node
    # Return the degree of this node.
    attr_accessor :degree

    # Return the parent of this node or nil if there is none.
    attr_accessor :p

    # Return whether this node is marked or not.
    attr_accessor :mark

    # Return the list of child nodes for this node.
    attr_accessor :child_list

    # Return the node to the right of this one.
    alias right next

    # Return the node to the left of this one.
    alias left prev

    # Return a new node with a given key and optional value.
    #
    # The key must be comparable and the value can be any arbitrary object.
    #
    # Defaults to using the key as a value.
    def initialize(key, value = key)
      super

      @child_list = CircularDoublyLinkedList.new
    end
  end

  # Return the current number of nodes in the heap.
  attr_accessor :n
  alias size n
  alias length n

  # Return the smallest node in the heap.
  attr_accessor :min

  # Return the root list of the heap.
  attr_accessor :root_list

  # Return a new, empty Fibonacci heap.
  def initialize
    @n = 0
    @min = nil
  end

  # Insert a new node with an optional key into the heap.
  #
  # The node must be compatible with a FibonacciHeap::Node.
  #
  # Defaults to using the existing key of the node.
  #
  # Corresponds to the Fib-Heap-Insert(H, x) procedure.
  def insert(x, k = x.key)
    x.degree = 0
    x.p = nil
    x.child_list = CircularDoublyLinkedList.new
    x.mark = false
    x.key = k

    if !min
      # Create a root list for H containing just x
      self.root_list = CircularDoublyLinkedList.new
      root_list.insert(x)

      self.min = x
    else
      # Insert x into H's root list
      root_list.insert(x)

      self.min = x if x.key < min.key
    end

    self.n += 1
  end

  # Unite the given Fibonacci heap into this one, returning a new heap.
  #
  # Note that uniting the heaps will mutate their root lists, destroying them
  # both so attempting to use them has undefined behaviour.
  #
  # Corresponds to the Fib-Heap-Union(H1, H2) procedure.
  def concat(h2)
    h = self.class.new
    h.min = min

    h.root_list = root_list
    h.root_list.concat(h2.root_list)

    h.min = h2.min if !min || (h2.min && h2.min.key < min.key)

    h.n = n + h2.n

    h
  end

  # Remove and return the minimum node from the heap.
  #
  # After extracting the minimum node, the heap will consolidate its internal
  # trees.
  #
  # Corresponds to the Fib-Heap-Extract-Min(H) procedure.
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
        # Set min to another root
        self.min = root_list.head

        consolidate
      end

      self.n -= 1
    end

    z
  end

  # Decrease the key of a given node to a new given key.
  #
  # The node must be compatible with a FibonacciHeap::Node and have been inserted
  # in the heap already. The key must be comparable.
  #
  # Raises an InvalidKeyError if the new key is greater than the current key.
  #
  # Corresponds to the Fib-Heap-Decrease-Key(H, x, k) procedure.
  def decrease_key(x, k)
    raise InvalidKeyError, "new key #{k} is greater than current key #{x.key}" if k > x.key

    x.key = k
    y = x.p

    if y && x.key < y.key
      cut(x, y)
      cascading_cut(y)
    end

    self.min = x if x.key < min.key
  end

  # Delete a node from the heap.
  #
  # The given node must be compatible with a FibonacciHeap::Node and have been
  # inserted in the heap already.
  #
  # Corresponds to the Fib-Heap-Delete(H, x) procedure.
  def delete(x)
    decrease_key(x, -1.0 / 0.0)
    pop
  end

  def inspect
    %(#<#{self.class} n=#{n} min=#{min.inspect}>)
  end

  private

  # Corresponds to the Consolidate(H) procedure.
  def consolidate
    degrees = []

    root_list.each do |w|
      x = w
      d = x.degree

      while degrees[d]
        y = degrees[d]

        x, y = y, x if x.key > y.key

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

      root_list.insert(root)

      if !min
        self.min = root
      elsif root.key < min.key
        self.min = root
      end
    end
  end

  # Corresponds to the Fib-Heap-Link(H, y, x) procedure.
  def link(y, x)
    # remove y from the root list of H
    root_list.delete(y)
    # make y a child of x, incrementing x.degree
    x.child_list.insert(y)
    x.degree += 1
    y.p = x
    y.mark = false
  end

  # Corresponds to the Cut(H, x, y) procedure.
  def cut(x, y)
    y.child_list.delete(x)
    y.degree -= 1
    root_list.insert(x)
    x.p = nil
    x.mark = false
  end

  # Corresponds to the Cascading-Cut(H, y) procedure.
  def cascading_cut(y)
    z = y.p
    return unless z

    if !y.mark
      y.mark = true
    else
      cut(y, z)
      cascading_cut(z)
    end
  end
end
