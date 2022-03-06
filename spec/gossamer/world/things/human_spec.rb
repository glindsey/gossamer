# frozen_string_literal: true

RSpec.describe Gossamer::World::Things::Human do
  context 'when created without options' do
    subject(:human) { described_class.new }

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

    it 'is steve' do
      expect(human.is?(:steve)).to eq(true)
    end

    it 'has a left leg and a right leg' do
      expect(human.parts?(:left_leg, :right_leg)).to eq(true)
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

    it 'incorporates a left eye and a right eye' do
      expect(human.incorporates?(:left_eye, :right_eye)).to eq(true)
    end
  end
end
