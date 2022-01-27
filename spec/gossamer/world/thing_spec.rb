# frozen_string_literal: true

RSpec.describe Gossamer::World::Thing do
  subject(:thing) { described_class.new(world) }

  let(:world) { Gossamer::World.new }

  it 'can be instantiated' do
    expect { described_class.new(world) }.not_to raise_error
  end

  it 'sets the "creatable" implication to true' do
    expect(thing.world.implications[:creatable]).to be(true)
  end
end
