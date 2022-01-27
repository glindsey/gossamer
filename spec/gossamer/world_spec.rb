# frozen_string_literal: true

RSpec.describe Gossamer::World do
  subject(:world) { described_class.new }

  it 'can be instantiated' do
    expect { described_class.new }.not_to raise_error
  end

  it 'has accessible rules' do
    expect(world.rules).to be_a(Gossamer::World::Rules)
  end
end
