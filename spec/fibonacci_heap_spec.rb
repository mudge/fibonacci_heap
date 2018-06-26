require 'fibonacci_heap'
require 'pry'

RSpec.describe FibonacciHeap do
  it 'initializes n to 0' do
    heap = described_class.new

    expect(heap.n).to be_zero
  end

  it 'initializes min to nil' do
    heap = described_class.new

    expect(heap.min).to be_nil
  end

  it 'can move child_list from nodes to the root list' do
    heap = described_class.new
    parent = described_class::Node.new('parent')
    child = described_class::Node.new('child')
    parent.child_list.insert(child)
    child.p = parent

    heap.insert(parent)
    parent.child_list.delete(child)
    heap.root_list.insert(child)
    child.p = nil

    expect(heap.root_list).to include(child)
    expect(parent.child_list).not_to include(child)
  end

  it 'can move roots to the child_list of a node' do
    heap = described_class.new
    root = described_class::Node.new('root')
    parent = described_class::Node.new('parent')

    heap.insert(root)
    heap.insert(parent)

    heap.root_list.delete(root)
    parent.child_list.insert(root)
    root.p = parent

    expect(heap.root_list).to contain_exactly(parent)
    expect(parent.child_list).to contain_exactly(root)
  end

  it 'can have nodes removed from the root list' do
    heap = described_class.new
    root = described_class::Node.new('root')

    heap.insert(root)
    heap.root_list.delete(root)

    expect(heap.root_list).to be_empty
    expect(heap.root_list.to_a).to eq([])
  end

  it 'distinguishes a single root by linking together left and right' do
    heap = described_class.new
    root = described_class::Node.new('root')

    heap.insert(root)

    expect(root.left).to eq(root.right)
  end

  it 'does not link together left and right for multiple roots' do
    heap = described_class.new
    root = described_class::Node.new('foo')
    root2 = described_class::Node.new('foo')

    heap.insert(root)
    heap.insert(root2)

    expect(root.left).not_to eq(root.right)
    expect(root2.left).not_to eq(root2.right)
  end

  describe '#insert' do
    it 'adds the node to the root list' do
      heap = described_class.new
      node = described_class::Node.new('foo')

      heap.insert(node)

      expect(heap.root_list).to include(node)
    end

    it 'sets the node to min for an empty heap' do
      heap = described_class.new
      node = described_class::Node.new('foo')

      heap.insert(node)

      expect(heap.min).to eq(node)
    end

    it 'does not override min if a smaller node already exists' do
      heap = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')

      heap.insert(node2)
      heap.insert(node)

      expect(heap.min).to eq(node2)
    end

    it 'overrides min if the new node is smallest' do
      heap = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')

      heap.insert(node)
      heap.insert(node2)

      expect(heap.min).to eq(node2)
    end

    it 'increases the number of nodes in the heap' do
      heap = described_class.new
      node = described_class::Node.new('foo')

      heap.insert(node)

      expect(heap.n).to eq(1)
    end
  end

  describe '#pop' do
    it 'returns nil if the heap is empty' do
      heap = described_class.new

      expect(heap.pop).to be_nil
    end

    it 'returns the smallest node' do
      heap = described_class.new
      node = described_class::Node.new(1)
      node2 = described_class::Node.new(2)

      heap.insert(node)
      heap.insert(node2)

      expect(heap.pop).to eq(node)
    end

    it 'works with more than two nodes' do
      heap = described_class.new
      node = described_class::Node.new(-1)
      heap.insert(node)

      25.times do |i|
        heap.insert(described_class::Node.new(i))
      end

      expect(heap.pop).to eq(node)
    end

    it 'decreases the size of the heap' do
      heap = described_class.new
      node = described_class::Node.new(1)
      node2 = described_class::Node.new(2)

      heap.insert(node)
      heap.insert(node2)
      heap.pop

      expect(heap.n).to eq(1)
    end

    it 'works when the min is in the middle of a tree' do
      heap = described_class.new
      node = described_class::Node.new(4)
      node2 = described_class::Node.new(2)
      node3 = described_class::Node.new(1)
      node4 = described_class::Node.new(3)

      heap.insert(node)
      heap.insert(node2)
      heap.insert(node3)
      heap.insert(node4)

      expect(heap.pop).to eq(node3)
      expect(heap.pop).to eq(node2)
      expect(heap.pop).to eq(node4)
      expect(heap.pop).to eq(node)
    end
  end

  describe '#decrease_key' do
    it 'raises an error if the key is greater than the existing value' do
      heap = described_class.new
      node = described_class::Node.new(1)
      heap.insert(node)

      expect { heap.decrease_key(node, 4) }.to raise_error(FibonacciHeap::InvalidKeyError)
    end

    it 'decreases the key of the node' do
      heap = described_class.new
      node = described_class::Node.new(2)
      node2 = described_class::Node.new(3)
      heap.insert(node)
      heap.insert(node2)

      heap.decrease_key(node2, 1)

      expect(node2.key).to eq(1)
    end

    it 'updates the min of the heap' do
      heap = described_class.new
      node = described_class::Node.new(2)
      node2 = described_class::Node.new(3)
      heap.insert(node)
      heap.insert(node2)

      heap.decrease_key(node2, 1)

      expect(heap.min).to eq(node2)
    end
  end

  describe '#delete' do
    it 'removes the node from the heap' do
      heap = described_class.new
      node = described_class::Node.new(2)
      node2 = described_class::Node.new(1)
      heap.insert(node)
      heap.insert(node2)

      heap.delete(node)

      expect(heap.pop).to eq(node2)
      expect(heap.pop).to be_nil
    end
  end
end
