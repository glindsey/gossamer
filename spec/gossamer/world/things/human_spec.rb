# frozen_string_literal: true

RSpec.describe Gossamer::World::Things::Human do
  context 'when created without options' do
    subject(:human) { pool.create(described_class) }

    let(:pool) { ::Gossamer::World::ThingPool.new }

    it 'can be instantiated' do
      expect { human }.not_to raise_error
    end

    it 'is a mammal' do
      expect(human.is_a?(:mammal)).to eq(true)
    end

    it 'is mammalian' do
      expect(human.is?(:mammalian)).to eq(true)
    end

    it 'is a humanoid' do
      expect(human.is_a?(:humanoid)).to eq(true)
    end

    it 'is humanoid' do
      expect(human.is?(:humanoid)).to eq(true)
    end

    it 'is a lifeform' do
      expect(human.is_a?(:lifeform)).to eq(true)
    end

    it 'has a left leg' do
      expect(human.parts?(:left_leg)).to eq(true)
    end

    it 'has a left leg and a right leg (searched by symbol)' do
      expect(human.parts?(:left_leg, :right_leg)).to eq(true)
    end

    it 'has a left leg (searched by type and criteria)' do
      expect(human.part?(:leg) { |part| part.tag?(:left) }).to eq(true)
    end

    it 'does not have a middle leg' do
      expect(human.part?(:leg) { |part| part.tag?(:middle) }).to eq(false)
    end

    it 'has a left arm and a right arm' do
      expect(human.parts?(:left_arm, :right_arm)).to eq(true)
    end

    it 'has a torso' do
      expect(human.part?(:torso)).to eq(true)
    end

    it 'has an abdomen' do
      expect(human.part?(:abdomen)).to eq(true)
    end

    it 'has a head' do
      expect(human.part?(:head)).to eq(true)
    end

    it 'has a head which has a left eye and right eye' do
      expect(human.part(:head).parts?(:left_eye, :right_eye)).to eq(true)
    end

    it 'incorporates a left eye and a right eye (searched by symbol)' do
      expect(human.incorporates?(:left_eye, :right_eye)).to eq(true)
    end

    it 'incorporates a left eye (searched by type and criteria)' do
      expect(human.incorporates?(:eye) { |part| part.tag?(:left) }).to eq(true)
    end

    it 'does not incorporate a middle eye' do
      expect(
        human.incorporates?(:eye) { |part| part.tag?(:middle) }
      ).to eq(false)
    end
  end
end
