module FibonacciHeap
  # A single node in a Fibonacci Heap.
  #
  # Contains a key and optional value that can be any arbitrary object.
  # The key will be used to sort nodes so that the key of a node is greater
  # than or equal to the key of its parent.
  #
  # Defaults to storing the key as the value.
  class Node
    # Return the key of the node.
    attr_accessor :key

    # Return the value of the node.
    attr_accessor :value

    # Return the node next to this one.
    attr_accessor :next
    alias right next

    # Return the node previous to this one.
    attr_accessor :prev
    alias left prev

    # Return the degree of this node.
    attr_accessor :degree

    # Return the parent of this node or nil if there is none.
    attr_accessor :p

    # Return whether this node is marked or not.
    attr_accessor :mark

    # Return the list of child nodes for this node.
    attr_accessor :child_list

    # Return a new node with the given key and optional value.
    #
    # The key and value can be any arbitrary object.
    #
    # The node's next and previous pointers will default to itself.
    #
    # Defaults the value to the key.
    def initialize(key, value = key)
      @key = key
      @value = value
      @next = self
      @prev = self
    end

    def inspect
      %(#<#{self.class} key=#{key.inspect} value=#{value.inspect}>)
    end
  end
end
