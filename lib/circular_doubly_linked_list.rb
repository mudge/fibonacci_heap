class CircularDoublyLinkedList
  include Enumerable

  class Node
    include Comparable

    attr_accessor :key, :next, :prev
    alias right next
    alias left prev

    def initialize(key)
      @key = key
      @next = self
      @prev = self
    end

    def <=>(other)
      key <=> other.key
    end
  end

  attr_accessor :sentinel

  def initialize
    @sentinel = Node.new(nil)
  end

  def head
    return if empty?

    sentinel.next
  end

  def tail
    return if empty?

    sentinel.prev
  end

  def empty?
    sentinel.next == sentinel
  end

  def insert(x)
    x.next = sentinel.next
    sentinel.next.prev = x
    sentinel.next = x
    x.prev = sentinel
  end

  def delete(x)
    x.prev.next = x.next
    x.next.prev = x.prev
  end

  def concat(list)
    list.sentinel.prev.next = sentinel.next
    sentinel.next.prev = list.sentinel.prev
    sentinel.next = list.sentinel.next
    list.sentinel.prev = sentinel
  end

  def each
    x = sentinel.next

    while x != sentinel
      current = x
      x = x.next

      yield current
    end
  end
end
