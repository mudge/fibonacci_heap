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

  describe '#insert' do
    it 'adds the node to the root list' do
      heap = described_class.new
      node = described_class::Node.new('foo')

      heap.insert(node)

      expect(heap).to include(node)
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

    it 'removes the smallest node from the heap' do
      heap = described_class.new
      node = described_class::Node.new(1)
      node2 = described_class::Node.new(2)

      heap.insert(node)
      heap.insert(node2)
      heap.pop

      expect(heap).to contain_exactly(node2)
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

      expect(heap).not_to include(node)
    end
  end
end
