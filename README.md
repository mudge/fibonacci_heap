# Fibonacci Heap [![Build Status](https://travis-ci.org/mudge/fibonacci_heap.svg?branch=master)](https://travis-ci.org/mudge/fibonacci_heap)

A Ruby implementation of the [Fibonacci heap](https://en.wikipedia.org/wiki/Fibonacci_heap) data structure ideal for use as a priority queue with [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra's_algorithm#Using_a_priority_queue).

**Current version:** 0.1.0  
**Supported Ruby versions:** 1.8.7, 1.9.2, 1.9.3, 2.0, 2.1, 2.2, 2.3

## Installation

```
gem install fibonacci_heap -v '~> 0.1'
```

Or, in your `Gemfile`:

```ruby
gem 'fibonacci_heap', '~> 0.1'
```

## Usage

```ruby
require 'fibonacci_heap'

heap = FibonacciHeap.new
foo = FibonacciHeap::Node.new(1, 'foo')
bar = FibonacciHeap::Node.new(0, 'bar')
heap.insert(foo)
heap.insert(bar)
heap.pop
#=> #<FibonacciHeap::Node key=0 value="bar">
```

## API Documentation

* [`FibonacciHeap`](#fibonacciheap)
  * [`.new`](#fibonacciheapnew)
  * [`#n`](#fibonacciheapn)
  * [`#size`](#fibonacciheapn)
  * [`#length`](#fibonacciheapn)
  * [`#min`](#fibonacciheapmin)
  * [`#insert(x[, k])`](#fibonacciheapinsertx-k)
  * [`#concat(h2)`](#fibonacciheapconcath2)
  * [`#pop`](#fibonacciheappop)
  * [`#decrease_key(x, k)`](#fibonacciheapdecrease_keyx-k)
  * [`#delete(x)`](#fibonacciheapdeletex)
  * [`Node`](#fibonacciheapnode)
    * [`new(key[, value])`](#fibonacciheapnodenewkey-value)
    * [`key`](#fibonacciheapnodekey)
    * [`value`](#fibonacciheapnodevalue)
  * [`InvalidKeyError`](#fibonacciheapinvalidkeyerror)

### `FibonacciHeap`

A Fibonacci Heap data structure.

A "mergeable heap" that supports several operations that run in
constant amortized time. Structured as a collection of rooted trees
that are min-heap ordered.

#### `FibonacciHeap.new`

```ruby
heap = FibonacciHeap.new
#=> #<FibonacciHeap n=0 min=nil>
```

Return a new, empty `FibonacciHeap` instance.

#### `FibonacciHeap#n`

```ruby
heap = FibonacciHeap.new
heap.insert(FibonacciHeap::Node.new('foo'))
heap.n
#=> 1
heap.size
#=> 1
heap.length
#=> 1
```

Return the current number of nodes in the heap.

Aliased to `size` and `length`.

#### `FibonacciHeap#min`

```ruby
heap = FibonacciHeap.new
heap.insert(FibonacciHeap::Node.new(1))
heap.insert(FibonacciHeap::Node.new(2))
heap.min
#=> #<FibonacciHeap::Node key=1 ...>
```

Return the smallest `FibonacciHeap::Node` node in the heap as determined by the node's `key`.

Will return `nil` if the heap is empty.

#### `FibonacciHeap#insert(x[, k])`

```ruby
heap = FibonacciHeap.new
node = FibonacciHeap::Node.new(1, 'foo')
node2 = FibonacciHeap::Node.new(0, 'bar')
heap.insert(node)
heap.insert(bar, 100)
```

Insert the given `FibonacciHeap::Node` `x` into the heap with an optional key `k`.

Defaults to using `x`'s existing `key` for `k`.

#### `FibonacciHeap#concat(h2)`

```ruby
heap = FibonacciHeap.new
heap.insert(FibonacciHeap::Node.new(1, 'foo'))
heap2 = FibonacciHeap.new
heap2.insert(FibonacciHeap::Node.new(2, 'bar'))

heap3 = heap.concat(heap2)
#=> #<FibonacciHeap n=2 min=#<FibonacciHeap::Node key=1 value="foo">>

heap3.pop
#=> #<FibonacciHeap::Node key=1 value="foo" ...>
heap3.pop
#=> #<FibonacciHeap::Node key=2 value="bar" ...>
```

Unite the given `FibonacciHeap` `h2` with this one in a new `FibonacciHeap`.

As this will mutate both collections of rooted trees, attempting to use either the original heap or `h2` after `concat` has undefined behaviour.

#### `FibonacciHeap#pop`

```ruby
heap = FibonacciHeap.new
heap.insert(FibonacciHeap::Node.new(1, 'foo'))
heap.pop
#=> #<FibonacciHeap::Node key=1 value="foo" ...>
```

Remove and return the smallest `FibonacciHeap::Node` from the heap.

#### `FibonacciHeap#decrease_key(x, k)`

```ruby
heap = FibonacciHeap.new
node = FibonacciHeap::Node.new(1, 'foo')
heap.insert(node)
heap.decrease_key(node, 0)
#=> #<FibonacciHeap::Node key=0 value="foo">
```

Decrease the key of the given `FibonacciHeap::Node` `x` to the new given key `k`.

The node must already be inserted into the heap and the key must be comparable.

Raises a `FibonacciHeap::InvalidKeyError` if the new key is greater than the current key.

#### `FibonacciHeap#delete(x)`

```ruby
heap = FibonacciHeap.new
node = FibonacciHeap::Node.new(1, 'foo')
heap.insert(node)
heap.delete(node)
#=> #<FibonacciHeap::Node key=-Infinity value="foo">
```

Deletes the given `FibonacciHeap::Node` `x` from the heap.

The node must already be inserted into the heap.

#### `FibonacciHeap::Node`

A single node in a `FibonacciHeap`.

Used internally to form both min-heap ordered trees and circular, doubly linked lists.

##### `FibonacciHeap::Node.new(key[, value])`

```ruby
node = FibonacciHeap::Node.new(1)
#=> #<FibonacciHeap::Node key=1 value=1>
node = FibonacciHeap::Node.new(1, 'foo')
#=> #<FibonacciHeap::Node key=1 value="foo">
```

Return a new `FibonacciHeap::Node` with the given key `key` and an optional value `value`.

Defaults to using the `key` as the value.

##### `FibonacciHeap::Node#key`

```ruby
node = FibonacciHeap::Node.new(1, 'foo')
node.key
#=> 1
```

Return the current key of the node.

##### `FibonacciHeap::Node#value`

```ruby
node = FibonacciHeap::Node.new(1, 'foo')
node.value
#=> "foo"
```

Return the current value of the node.

#### `FibonacciHeap::InvalidKeyError`

Raised when attempting to decrease a key but the key is greater than the current key.

## References

* Cormen, T. H., Leiserson, C. E., Rivest, R. L. & Stein, C., [Introduction to Algorithms, Third Edition](https://mitpress.mit.edu/books/introduction-algorithms-third-edition).

## License

Copyright © 2018 Paul Mucur

Distributed under the MIT License.
