# frozen_string_literal: true

def incorporates_pair(subject, part_sym)
  %i[left right].all? do |adj|
    subject.incorporates?(part_sym) { |part| part.tag?(adj) }
  end
end

RSpec.describe Gossamer::World::Things::Human do
  context 'when created without options' do
    subject(:human) { pool.create(described_class) }

    let(:pool) { ::Gossamer::World::ThingPool.new }

    it 'can be instantiated' do
      expect { human }.not_to raise_error
    end

    it 'is a mammal' do
      expect(human.is_a?(:mammal)).to be(true)
    end

    it 'is mammalian' do
      expect(human.is?(:mammalian)).to be(true)
    end

    it 'is a humanoid' do
      expect(human.is_a?(:humanoid)).to be(true)
    end

    it 'is humanoid' do
      expect(human.is?(:humanoid)).to be(true)
    end

    it 'is a lifeform' do
      expect(human.is_a?(:lifeform)).to be(true)
    end

    it 'has a torso' do
      expect(human.part?(:torso)).to be(true)
    end

    it 'incorporates left and right arms' do
      expect(human.incorporates_a_pair_of?(:arms)).to be(true)
    end

    it 'incorporates a left hand and a right hand' do
      expect(
        %i[left right].all? do |adj|
          human.incorporates?(:hand) { |part| part.tag?(adj) }
        end
      ).to be(true)
    end

    it 'has an abdomen' do
      expect(human.part?(:abdomen)).to be(true)
    end

    it 'incorporates a left leg' do
      expect(human.incorporates?(:left_leg)).to be(true)
    end

    it 'incorporates a left leg and a right leg (searched by symbol)' do
      expect(human.incorporates?(:left_leg, :right_leg)).to be(true)
    end

    it 'incorporates left and right legs (searched by type and criteria)' do
      expect(incorporates_pair(human, :leg)).to be(true)
    end

    it 'does not incorporate a middle leg' do
      expect(
        human.incorporates?(:leg) { |part| part.tag?(:middle) }
      ).to be(false)
    end

    it 'incorporates left and right feet' do
      expect(incorporates_pair(human, :foot)).to be(true)
    end

    it 'has a head' do
      expect(human.part?(:head)).to be(true)
    end

    it 'has a head which has a left eye and right eye' do
      expect(human.part(:head).parts?(:left_eye, :right_eye)).to be(true)
    end

    it 'incorporates left and right eyes' do
      expect(incorporates_pair(human, :eye)).to be(true)
    end

    it 'incorporates left and right ears' do
      expect(incorporates_pair(human, :ear)).to be(true)
    end

    it 'incorporates a nose' do
      expect(human.incorporates?(:nose)).to be(true)
    end

    it 'incorporates a mouth' do
      expect(human.incorporates?(:mouth)).to be(true)
    end

    it 'does not incorporate a middle eye' do
      expect(
        human.incorporates?(:eye) { |part| part.tag?(:middle) }
      ).to be(false)
    end
  end
end
