# frozen_string_literal: true

require 'awesome_print'

RSpec.describe Gossamer::YamlLoader do
  subject(:loader) { described_class.new }

  let(:data_path) { File.expand_path(File.join(__dir__, '..', '..', 'data')) }

  it 'loads data from the data directory without raising an exception' do
    expect do
      ap loader.parse(data_path)
    end.not_to raise_error
  end
end
