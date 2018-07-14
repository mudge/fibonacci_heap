# Fibonacci Heap [![Build Status](https://travis-ci.org/mudge/fibonacci_heap.svg?branch=master)](https://travis-ci.org/mudge/fibonacci_heap)

A Ruby implementation of the [Fibonacci heap](https://en.wikipedia.org/wiki/Fibonacci_heap) data structure ideal for use as a priority queue with [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra's_algorithm#Using_a_priority_queue).

**Current version:** 0.2.0  
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

heap = FibonacciHeap::Heap.new
foo = FibonacciHeap::Node.new(1, 'foo')
bar = FibonacciHeap::Node.new(0, 'bar')
heap.insert(foo)
heap.insert(bar)
heap.pop
#=> #<FibonacciHeap::Node key=0 value="bar">
```

## API Documentation

* [`FibonacciHeap::Heap`](#fibonacciheapheap)
  * [`.new`](#fibonacciheapheapnew)
  * [`#n`](#fibonacciheapheapn)
  * [`#size`](#fibonacciheapheapn)
  * [`#length`](#fibonacciheapheapn)
  * [`#empty?`](#fibonacciheapheapempty)
  * [`#min`](#fibonacciheapheapmin)
  * [`#insert(x[, k])`](#fibonacciheapheapinsertx-k)
  * [`#concat(h2)`](#fibonacciheapheapconcath2)
  * [`#pop`](#fibonacciheapheappop)
  * [`#decrease_key(x, k)`](#fibonacciheapheapdecrease_keyx-k)
  * [`#delete(x)`](#fibonacciheapheapdeletex)
  * [`#clear`](#fibonacciheapheapclear)
* [`FibonacciHeap::Node`](#fibonacciheapnode)
  * [`new(key[, value])`](#fibonacciheapnodenewkey-value)
  * [`key`](#fibonacciheapnodekey)
  * [`value`](#fibonacciheapnodevalue)
* [`FibonacciHeap::InvalidKeyError`](#fibonacciheapinvalidkeyerror)

### `FibonacciHeap::Heap`

A Fibonacci Heap data structure.

A "mergeable heap" that supports several operations that run in
constant amortized time. Structured as a collection of rooted trees
that are min-heap ordered.

#### `FibonacciHeap::Heap.new`

```ruby
heap = FibonacciHeap::Heap.new
#=> #<FibonacciHeap n=0 min=nil>
```

Return a new, empty [`FibonacciHeap::Heap`](#fibonacciheapheap) instance.

#### `FibonacciHeap::Heap#n`

```ruby
heap = FibonacciHeap::Heap.new
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

#### `FibonacciHeap::Heap#empty?`

```ruby
heap = FibonacciHeap::Heap.new
heap.empty?
#=> true
```

Returns whether or not the heap is empty.

#### `FibonacciHeap::Heap#min`

```ruby
heap = FibonacciHeap::Heap.new
heap.insert(FibonacciHeap::Node.new(1))
heap.insert(FibonacciHeap::Node.new(2))
heap.min
#=> #<FibonacciHeap::Node key=1 ...>
```

Return the smallest [`FibonacciHeap::Node`](#fibonacciheapnode) node in the heap as determined by the node's `key`.

Will return `nil` if the heap is empty.

#### `FibonacciHeap::Heap#insert(x[, k])`

```ruby
heap = FibonacciHeap::Heap.new
node = FibonacciHeap::Node.new(1, 'foo')
node2 = FibonacciHeap::Node.new(0, 'bar')
heap.insert(node)
heap.insert(bar, 100)
```

Insert the given [`FibonacciHeap::Node`](#fibonacciheapnode) `x` into the heap with an optional key `k`.

Defaults to using `x`'s existing `key` for `k`.

#### `FibonacciHeap::Heap#concat(h2)`

```ruby
heap = FibonacciHeap::Heap.new
heap.insert(FibonacciHeap::Node.new(1, 'foo'))
heap2 = FibonacciHeap::Heap.new
heap2.insert(FibonacciHeap::Node.new(2, 'bar'))

heap3 = heap.concat(heap2)
#=> #<FibonacciHeap::Heap n=2 min=#<FibonacciHeap::Node key=1 value="foo">>

heap3.pop
#=> #<FibonacciHeap::Node key=1 value="foo" ...>
heap3.pop
#=> #<FibonacciHeap::Node key=2 value="bar" ...>
```

Unite the given [`FibonacciHeap::Heap`](#fibonacciheapheap) `h2` with this one in a new [`FibonacciHeap::Heap`](#fibonacciheapheap).

As this will mutate both collections of rooted trees, attempting to use either the original heap or `h2` after `concat` has undefined behaviour.

#### `FibonacciHeap::Heap#pop`

```ruby
heap = FibonacciHeap::Heap.new
heap.insert(FibonacciHeap::Node.new(1, 'foo'))
heap.pop
#=> #<FibonacciHeap::Node key=1 value="foo" ...>
```

Remove and return the smallest [`FibonacciHeap::Node`](#fibonacciheapnode) from the heap.

#### `FibonacciHeap::Heap#decrease_key(x, k)`

```ruby
heap = FibonacciHeap::Heap.new
node = FibonacciHeap::Node.new(1, 'foo')
heap.insert(node)
heap.decrease_key(node, 0)
#=> #<FibonacciHeap::Node key=0 value="foo">
```

Decrease the key of the given [`FibonacciHeap::Node`](#fibonacciheapnode) `x` to the new given key `k`.

The node must already be inserted into the heap and the key must be comparable.

Raises a [`FibonacciHeap::InvalidKeyError`](#fibonacciheapinvalidkeyerror) if the new key is greater than the current key.

#### `FibonacciHeap::Heap#delete(x)`

```ruby
heap = FibonacciHeap::Heap.new
node = FibonacciHeap::Node.new(1, 'foo')
heap.insert(node)
heap.delete(node)
#=> #<FibonacciHeap::Node key=-Infinity value="foo">
```

Deletes the given [`FibonacciHeap::Node`](#fibonacciheapnode) `x` from the heap.

The node must already be inserted into the heap.

#### `FibonacciHeap::Heap#clear`

```ruby
heap = FibonacciHeap::Heap.new
heap.insert(FibonacciHeap::Node.new(1, 'foo'))
heap.clear
#=> #<FibonacciHeap::Heap n=0 min=nil>
```

Remove all nodes from the heap, emptying it.

### `FibonacciHeap::Node`

A single node in a [`FibonacciHeap::Heap`](#fibonacciheapheap).

Used internally to form both min-heap ordered trees and circular, doubly linked lists.

#### `FibonacciHeap::Node.new(key[, value])`

```ruby
node = FibonacciHeap::Node.new(1)
#=> #<FibonacciHeap::Node key=1 value=1>
node = FibonacciHeap::Node.new(1, 'foo')
#=> #<FibonacciHeap::Node key=1 value="foo">
```

Return a new [`FibonacciHeap::Node`](#fibonacciheapnode) with the given key `key` and an optional value `value`.

Defaults to using the `key` as the value.

#### `FibonacciHeap::Node#key`

```ruby
node = FibonacciHeap::Node.new(1, 'foo')
node.key
#=> 1
```

Return the current key of the node.

#### `FibonacciHeap::Node#value`

```ruby
node = FibonacciHeap::Node.new(1, 'foo')
node.value
#=> "foo"
```

Return the current value of the node.

### `FibonacciHeap::InvalidKeyError`

Raised when attempting to decrease a key but the new key is greater than the current key.

## References

* Cormen, T. H., Leiserson, C. E., Rivest, R. L. & Stein, C., [Introduction to Algorithms, Third Edition](https://mitpress.mit.edu/books/introduction-algorithms-third-edition).

## License

Copyright © 2018 Paul Mucur

Distributed under the MIT License.
