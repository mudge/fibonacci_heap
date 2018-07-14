require 'fibonacci_heap'

module FibonacciHeap
  RSpec.describe Heap do
    it 'initializes n to 0' do
      heap = described_class.new

      expect(heap.n).to be_zero
    end

    it 'initializes min to nil' do
      heap = described_class.new

      expect(heap.min).to be_nil
    end

    describe '#inspect' do
      it 'lists the size and min of the heap' do
        heap = described_class.new
        heap.insert(Node.new(1, 'foo'))

        expect(heap.inspect).to eq('#<FibonacciHeap::Heap n=1 min=#<FibonacciHeap::Node key=1 value="foo">>')
      end
    end

    describe '#clear' do
      it 'empties the heap' do
        heap = described_class.new
        heap.insert(Node.new(1, 'foo'))

        heap.clear

        expect(heap).to be_empty
      end

      it 'clears the min node' do
        heap = described_class.new
        heap.insert(Node.new(1, 'foo'))

        heap.clear

        expect(heap.min).to be_nil
      end

      it 'empties the root list' do
        heap = described_class.new
        heap.insert(Node.new(1, 'foo'))

        heap.clear

        expect(heap.root_list).to be_empty
      end

      it 'returns the emptied heap' do
        heap = described_class.new
        heap.insert(Node.new(1, 'foo'))

        expect(heap.clear).to eq(heap)
      end
    end

    describe '#n' do
      it 'returns the size of the heap' do
        heap = described_class.new
        node = Node.new('foo')
        node2 = Node.new('foo')

        heap.insert(node)
        heap.insert(node2)

        expect(heap.n).to eq(2)
      end

      it 'is aliased to #size' do
        heap = described_class.new
        node = Node.new('foo')
        node2 = Node.new('foo')

        heap.insert(node)
        heap.insert(node2)

        expect(heap.size).to eq(2)
      end

      it 'is aliased to #length' do
        heap = described_class.new
        node = Node.new('foo')
        node2 = Node.new('foo')

        heap.insert(node)
        heap.insert(node2)

        expect(heap.length).to eq(2)
      end
    end

    describe '#empty?' do
      it 'returns true if the heap has no nodes' do
        heap = described_class.new

        expect(heap).to be_empty
      end

      it 'returns false if the heap has any nodes' do
        heap = described_class.new
        heap.insert(Node.new('foo'))

        expect(heap).to_not be_empty
      end
    end

    describe '#min' do
      it 'returns the smallest node in the heap' do
        heap = described_class.new
        node = Node.new(10)
        node2 = Node.new(0)

        heap.insert(node)
        heap.insert(node2)

        expect(heap.min).to eq(node2)
      end
    end

    describe '#insert' do
      it 'adds the node to the root list' do
        heap = described_class.new
        node = Node.new('foo')

        heap.insert(node)

        expect(heap.root_list).to include(node)
      end

      it 'sets the node to min for an empty heap' do
        heap = described_class.new
        node = Node.new('foo')

        heap.insert(node)

        expect(heap.min).to eq(node)
      end

      it 'does not override min if a smaller node already exists' do
        heap = described_class.new
        node = Node.new('foo')
        node2 = Node.new('bar')

        heap.insert(node2)
        heap.insert(node)

        expect(heap.min).to eq(node2)
      end

      it 'overrides min if the new node is smallest' do
        heap = described_class.new
        node = Node.new('foo')
        node2 = Node.new('bar')

        heap.insert(node)
        heap.insert(node2)

        expect(heap.min).to eq(node2)
      end

      it 'increases the number of nodes in the heap' do
        heap = described_class.new
        node = Node.new('foo')

        heap.insert(node)

        expect(heap.n).to eq(1)
      end

      it 'returns the inserted node' do
        heap = described_class.new
        node = Node.new('foo')

        expect(heap.insert(node)).to eq(node)
      end
    end

    describe '#pop' do
      it 'returns nil if the heap is empty' do
        heap = described_class.new

        expect(heap.pop).to be_nil
      end

      it 'returns the smallest node' do
        heap = described_class.new
        node = Node.new(1)
        node2 = Node.new(2)

        heap.insert(node)
        heap.insert(node2)

        expect(heap.pop).to eq(node)
      end

      it 'works with more than two nodes' do
        heap = described_class.new
        node = Node.new(-1)
        heap.insert(node)

        25.times do |i|
          heap.insert(Node.new(i))
        end

        expect(heap.pop).to eq(node)
      end

      it 'decreases the size of the heap' do
        heap = described_class.new
        node = Node.new(1)
        node2 = Node.new(2)

        heap.insert(node)
        heap.insert(node2)
        heap.pop

        expect(heap.n).to eq(1)
      end

      it 'works when the min is in the middle of a tree' do
        heap = described_class.new
        node = Node.new(4)
        node2 = Node.new(2)
        node3 = Node.new(1)
        node4 = Node.new(3)

        heap.insert(node)
        heap.insert(node2)
        heap.insert(node3)
        heap.insert(node4)

        expect(heap.pop).to eq(node3)
        expect(heap.pop).to eq(node2)
        expect(heap.pop).to eq(node4)
        expect(heap.pop).to eq(node)
      end

      it 'distinguishes a single root by linking together left and right' do
        heap = described_class.new
        root = Node.new('root')

        heap.insert(root)

        expect(root.left).to eq(root.right)
      end

      it 'does not link together left and right for multiple roots' do
        heap = described_class.new
        root = Node.new('foo')
        root2 = Node.new('foo')

        heap.insert(root)
        heap.insert(root2)

        expect(root.left).not_to eq(root.right)
        expect(root2.left).not_to eq(root2.right)
      end

      it 'removes the last node in the heap' do
        heap = described_class.new
        root = Node.new('foo')
        heap.insert(root)

        expect(heap.pop).to eq(root)
        expect(heap.pop).to be_nil
        expect(heap.min).to be_nil
      end

      it 'can have nodes inserted after being emptied' do
        heap = described_class.new
        root = Node.new('foo')
        heap.insert(root)
        heap.pop
        root2 = Node.new('bar')
        heap.insert(root2)

        expect(heap.pop).to eq(root2)
        expect(heap.pop).to be_nil
      end
    end

    describe '#decrease_key' do
      it 'raises an error if the key is greater than the existing value' do
        heap = described_class.new
        node = Node.new(1)
        heap.insert(node)

        expect { heap.decrease_key(node, 4) }.to raise_error(InvalidKeyError)
      end

      it 'decreases the key of the node' do
        heap = described_class.new
        node = Node.new(2)
        node2 = Node.new(3)
        heap.insert(node)
        heap.insert(node2)

        heap.decrease_key(node2, 1)

        expect(node2.key).to eq(1)
      end

      it 'updates the min of the heap' do
        heap = described_class.new
        node = Node.new(2)
        node2 = Node.new(3)
        heap.insert(node)
        heap.insert(node2)

        heap.decrease_key(node2, 1)

        expect(heap.min).to eq(node2)
      end

      it 'returns the decreased node' do
        heap = described_class.new
        node = Node.new(2)
        heap.insert(node)

        expect(heap.decrease_key(node, 1)).to eq(node)
      end
    end

    describe '#delete' do
      it 'removes the node from the heap' do
        heap = described_class.new
        node = Node.new(2)
        node2 = Node.new(1)
        heap.insert(node)
        heap.insert(node2)

        heap.delete(node)

        expect(heap.pop).to eq(node2)
        expect(heap.pop).to be_nil
      end

      it 'returns the deleted node' do
        heap = described_class.new
        node = Node.new(1)
        heap.insert(node)

        expect(heap.delete(node)).to eq(node)
      end
    end

    describe '#concat' do
      it 'unites the given heap with this one' do
        heap = described_class.new
        node = Node.new(1)
        heap2 = described_class.new
        node2 = Node.new(2)
        heap.insert(node)
        heap2.insert(node2)

        heap3 = heap.concat(heap2)

        expect(heap3.pop).to eq(node)
        expect(heap3.pop).to eq(node2)
        expect(heap3.pop).to be_nil
      end

      it 'unites an empty heap with a non-empty heap' do
        heap = described_class.new
        heap2 = described_class.new
        node = Node.new(1)
        heap2.insert(node)

        heap3 = heap.concat(heap2)

        expect(heap3.pop).to eq(node)
        expect(heap3.pop).to be_nil
      end

      it 'unites a non-empty heap with an empty heap' do
        heap = described_class.new
        heap2 = described_class.new
        node = Node.new(1)
        heap.insert(node)

        heap3 = heap.concat(heap2)

        expect(heap3.pop).to eq(node)
        expect(heap3.pop).to be_nil
      end

      it 'unites two empty heaps' do
        heap = described_class.new
        heap2 = described_class.new

        heap3 = heap.concat(heap2)

        expect(heap3.pop).to be_nil
      end
    end
  end
end
