require 'circular_doubly_linked_list'

RSpec.describe CircularDoublyLinkedList::Node do
  describe '#next' do
    it 'is initialized to itself by default' do
      node = described_class.new('foo')

      expect(node.next).to eq(node)
    end
  end

  describe '#prev' do
    it 'is initialized to itself by default' do
      node = described_class.new('foo')

      expect(node.prev).to eq(node)
    end
  end
end

RSpec.describe CircularDoublyLinkedList do
  describe '#insert' do
    it 'inserts the node into an empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')

      list.insert(node)

      expect(list).to contain_exactly(node)
    end

    it 'sets next and prev on the only node in a list' do
      list = described_class.new
      node = described_class::Node.new('foo')

      list.insert(node)

      expect(node.right).to eq(list.sentinel)
    end

    it 'sets the node as the head of an empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')

      list.insert(node)

      expect(list.head).to eq(node)
    end

    it 'sets the node as the tail of an empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')

      list.insert(node)

      expect(list.tail).to eq(node)
    end

    it 'inserts the node into a non-empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')

      list.insert(node)
      list.insert(node2)

      expect(list).to contain_exactly(node, node2)
    end

    it 'sets the new node as the new head in a non-empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')

      list.insert(node)
      list.insert(node2)

      expect(list.head).to eq(node2)
    end

    it 'retains the existing tail in a non-empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')

      list.insert(node)
      list.insert(node2)

      expect(list.tail).to eq(node)
    end

    it 'inserts into a list with more than two nodes' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')
      node3 = described_class::Node.new('baz')

      list.insert(node)
      list.insert(node2)
      list.insert(node3)

      expect(list).to contain_exactly(node, node2, node3)
    end
  end

  describe '#delete' do
    it 'removes the node from a list with only one node' do
      list = described_class.new
      node = described_class::Node.new('foo')

      list.insert(node)
      list.delete(node)

      expect(list).to be_empty
      expect(list.head).to be_nil
      expect(list.tail).to be_nil
      expect(list.to_a).to eq([])
    end

    it 'removes a node from the tail of a non-empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')

      list.insert(node)
      list.insert(node2)
      list.delete(node)

      expect(list).to contain_exactly(node2)
      expect(list.head).to eq(node2)
      expect(list.tail).to eq(node2)
    end

    it 'removes a node from the middle of a non-empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')
      node3 = described_class::Node.new('baz')

      list.insert(node)
      list.insert(node2)
      list.insert(node3)
      list.delete(node2)

      expect(list).to contain_exactly(node, node3)
      expect(list.tail).to eq(node)
      expect(list.head).to eq(node3)
    end

    it 'can remove all nodes from a non-empty list' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')
      node3 = described_class::Node.new('baz')

      list.insert(node)
      list.insert(node2)
      list.insert(node3)
      list.delete(node2)
      list.delete(node)
      list.delete(node3)

      expect(list).to be_empty
      expect(list.head).to be_nil
      expect(list.tail).to be_nil
      expect(list.to_a).to eq([])
    end

    it 'does not alter the pointers of the deleted node' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')
      node3 = described_class::Node.new('baz')

      list.insert(node)
      list.insert(node2)
      list.insert(node3)
      list.delete(node2)

      expect(node2.next).to eq(node)
      expect(node2.prev).to eq(node3)
    end
  end

  describe '#empty?' do
    it 'is true if there is no head node' do
      list = described_class.new

      expect(list).to be_empty
    end
  end

  describe '#each' do
    it 'yields nothing if the list is empty' do
      list = described_class.new

      expect { |b| list.each(&b) }.to yield_successive_args
    end

    it 'yields nodes' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')
      list.insert(node)
      list.insert(node2)

      expect { |b| list.each(&b) }.to yield_successive_args(node2, node)
    end

    it 'yields more than two nodes' do
      list = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')
      node3 = described_class::Node.new('baz')
      list.insert(node)
      list.insert(node2)
      list.insert(node3)

      expect { |b| list.each(&b) }.to yield_successive_args(node3, node2, node)
    end
  end

  describe '#concat' do
    it 'combines two lists' do
      list = described_class.new
      list2 = described_class.new
      node = described_class::Node.new('foo')
      node2 = described_class::Node.new('bar')
      node3 = described_class::Node.new('baz')
      node4 = described_class::Node.new('quux')
      list.insert(node)
      list.insert(node2)
      list2.insert(node3)
      list2.insert(node4)

      list.concat(list2)

      expect(list.to_a).to contain_exactly(node, node2, node3, node4)
    end
  end
end

