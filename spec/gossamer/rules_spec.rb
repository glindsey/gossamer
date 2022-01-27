# frozen_string_literal: true

require 'awesome_print'

RSpec.describe Gossamer::Rules do
  subject(:rules) { described_class.new }

  it 'initializes without raising an exception' do
    expect { rules }.not_to raise_error
  end
end
