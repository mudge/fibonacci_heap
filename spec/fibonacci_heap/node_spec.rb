require 'fibonacci_heap/node'

module FibonacciHeap
  RSpec.describe Node do
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

    describe '#inspect' do
      it 'lists the current key and value' do
        node = described_class.new(1, 'foo')

        expect(node.inspect).to eq('#<FibonacciHeap::Node key=1 value="foo">')
      end
    end
  end
end
