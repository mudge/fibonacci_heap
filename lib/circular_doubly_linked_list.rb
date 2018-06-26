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

  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def empty?
    !head
  end

  def insert(x)
    if !head
      x.next = x.prev = x
      self.head = x
      self.tail = head
    else
      x.prev = tail
      tail.next = x
      head.prev = x
      x.next = head
      self.tail = x
    end
  end

  def delete(x)
    if head == x
      if head == tail
        self.head = nil
        self.tail = nil
      else
        self.head = head.next
        head.prev = tail
        tail.next = head
      end
    elsif tail == x
      self.tail = tail.prev
      tail.next = head
      head.prev = tail
    else
      x.prev.next = x.next
      x.next.prev = x.prev
    end
  end

  def each
    x = head
    return unless x

    loop do
      yield x

      x = x.next
      break if x == head
    end
  end
end
