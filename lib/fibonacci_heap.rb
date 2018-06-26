require 'circular_doubly_linked_list'

class FibonacciHeap < CircularDoublyLinkedList
  InvalidKeyError = Class.new(StandardError)

  alias ll_insert insert
  alias ll_delete delete
  alias ll_each each

  class Node < CircularDoublyLinkedList
    attr_accessor :key, :next, :prev, :degree, :p, :mark
    alias right next
    alias left prev
    alias child head

    def initialize(key)
      @key = key
      @prev = self
      @next = self
      @degree = 0
      @mark = false

      super()
    end
  end

  attr_accessor :n
  alias min head
  alias min= head=

  def initialize
    @n = 0
  end

  def insert(x)
    x.degree = 0
    x.p = nil
    x.mark = false

    if !min
      ll_insert(x)

      self.min = x
    else
      ll_insert(x)

      if x.key < min.key
        self.min = x
      end
    end

    self.n += 1
  end

  def pop
    z = min

    if z
      z.each do |x|
        ll_insert(x)
        x.p = nil
      end

      ll_delete(z)

      if z == z.right
        self.min = nil
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
    degrees = []

    ll_each do |w|
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

    degrees.each do |degree, root|
      next unless root

      if !min
        root.prev = root.next = root
        ll_insert(root)
        self.min = root
      else
        ll_insert(root)
        if root.key < min.key
          self.min = root
        end
      end
    end
  end

  def link(y, x)
    ll_delete(y)
    y.next = y.prev = y
    x.insert(y)
    x.degree += 1
    y.p = x
    y.mark = false
  end

  def cut(x, y)
    y.delete(x)
    y.degree -= 1
    ll_insert(x)
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
