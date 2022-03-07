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
end
