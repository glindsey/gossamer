# frozen_string_literal: true

module Gossamer
  module World
    module Things
      class Dummy < Base
        include World::Traits::Concrete
      end
    end
  end
end

RSpec.describe Gossamer::World::ThingPool do
  subject(:pool) { described_class.new }

  it 'can be instantiated' do
    expect { pool }.not_to raise_error
  end

  describe '#create' do
    let(:dummy) { pool.create(:dummy) }

    it 'raises an error if passed something other than a Symbol or Class' do
      expect { pool.create(42) }.to raise_error(RuntimeError)
    end

    it 'can create a dummy object' do
      expect(dummy).to be_a(::Gossamer::World::Things::Dummy)
    end

    it 'sets the pool of the new object to itself' do
      expect(dummy.pool).to be(pool)
    end

    it 'sets the ID of the new object to be a UUID' do
      expect(dummy.id).to match(
        /\h{8}-\h{4}-\h{4}-\h{4}-\h{12}/
      )
    end
  end

  describe '#[]' do
    it 'raises an error if not provided a string' do
      expect { pool[42] }.to raise_error(RuntimeError)
    end

    it 'can locate created items by UUID' do
      dummy = pool.create(:dummy)

      expect(pool[dummy.id]).to eq(dummy)
    end

    it 'returns nil when a UUID is not found' do
      pool.create(:dummy)

      expect(pool['blah']).to eq(nil)
    end
  end

  describe '#delete' do
    it 'raises an error if not provided a string' do
      expect { pool.delete(42) }.to raise_error(RuntimeError)
    end

    it 'deletes an item when provided a valid UUID' do
      dummy = pool.create(:dummy)

      pool.delete(dummy.id)

      expect(pool[dummy.id]).to eq(nil)
    end

    it 'does not raise an error when provided a nonexistent UUID' do
      pool.create(:dummy)

      expect { pool.delete('blah') }.not_to raise_error
    end
  end
end
