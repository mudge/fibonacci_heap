module FibonacciHeap
  # A Circular Doubly Linked List data structure.
  #
  # An unsorted, linear, circular list with a sentinel to simplify
  # boundary conditions.
  class CircularDoublyLinkedList
    include Enumerable

    # A Sentinel node to simplify boundary conditions in the linked list.
    class Sentinel
      attr_accessor :next, :prev

      def initialize
        @next = self
        @prev = self
      end
    end

    # Return the special "sentinel" or Nil node for this list.
    attr_accessor :sentinel

    # Return a new, empty list.
    def initialize
      @sentinel = Sentinel.new
    end

    # Return the first element of the list or nil if it is empty.
    def head
      return if empty?

      sentinel.next
    end

    # Return the last element of the list or nil if it is empty.
    def tail
      return if empty?

      sentinel.prev
    end

    # Return whether or not the list is empty.
    def empty?
      sentinel.next == sentinel
    end

    # Insert a given node into the list.
    #
    # New nodes will be placed at the head of the list.
    def insert(x)
      x.next = sentinel.next
      sentinel.next.prev = x
      sentinel.next = x
      x.prev = sentinel
    end

    # Remove a given node from the list.
    #
    # The node must already be in the list.
    def delete(x)
      x.prev.next = x.next
      x.next.prev = x.prev
    end

    # Combine this list with another, destroying the given list.
    def concat(list)
      list.sentinel.prev.next = sentinel.next
      sentinel.next.prev = list.sentinel.prev
      sentinel.next = list.sentinel.next
      list.sentinel.prev = sentinel
    end

    # Yield each element of this list.
    def each
      x = sentinel.next

      while x != sentinel
        current = x
        x = x.next

        yield current
      end
    end
  end
end
