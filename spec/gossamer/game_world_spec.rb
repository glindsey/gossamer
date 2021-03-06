# frozen_string_literal: true

RSpec.describe Gossamer::GameWorld do
  subject(:world) { described_class.new }

  it 'can be instantiated' do
    expect { described_class.new }.not_to raise_error
  end
end
