# frozen_string_literal: true

RSpec.describe Gossamer::World::Things::Coin do
  context 'when not provided a shape or material' do
    subject(:thing) { described_class.new }

    it 'can NOT be instantiated' do
      expect { thing }.to raise_error(RuntimeError)
    end
  end

  context 'when provided a shape but no material' do
    subject(:thing) { described_class.new(attributes: { shape: :circle }) }

    it 'can NOT be instantiated' do
      expect { thing }.to raise_error(RuntimeError)
    end
  end

  context 'when provided a material but no shape' do
    subject(:thing) { described_class.new(material: :gold) }

    it 'can NOT be instantiated' do
      expect { thing }.to raise_error(RuntimeError)
    end
  end

  context 'when provided a material and a shape' do
    context 'when the material is abstract' do
      subject(:thing) do
        described_class.new(material: :metal, attributes: { shape: :square })
      end

      it 'can NOT be instantiated' do
        expect { thing }.to raise_error(RuntimeError)
      end
    end

    context 'when the shape is abstract' do
      subject(:thing) do
        described_class.new(material: :gold, attributes: { shape: :polygon })
      end

      it 'can NOT be instantiated' do
        expect { thing }.to raise_error(RuntimeError)
      end
    end

    context 'when the material and shape are both concrete' do
      subject(:thing) do
        described_class.new(material: :gold, attributes: { shape: :square })
      end

      it 'can be instantiated' do
        expect { thing }.not_to raise_error
      end
    end
  end
end
