# frozen_string_literal: true

RSpec.shared_examples('ParentComponent') do
  subject(:parent) { described_class.new }

  describe '#adopt' do
    let(:child) { described_class.new }

    it 'does nothing if the caller attempts to add a non-component child' do
      before_children = parent.children

      parent.adopt('not a component')

      expect(parent.children).to eq(before_children)
    end

    context 'when adding a child to a parent' do
      before do
        parent.adopt(child)
      end

      it 'adds the child to its list of children' do
        expect(parent.children).to eq([child])
      end

      it "sets the child's parent to itself" do
        expect(child.parent).to eq(parent)
      end
    end

    context 'when adding a child that the parent already has' do
      before do
        parent.adopt(child)
        parent.adopt(child)
      end

      it 'does not add the child more than once' do
        expect(parent.children).to eq([child])
      end
    end

    context 'when adding a child to a parent that already has children' do
      let(:other_child) { described_class.new }

      before do
        parent.adopt(child)
        parent.adopt(other_child)
      end

      it 'adds the child to its list of children' do
        expect(parent.children).to include(other_child)
      end

      it 'puts the new child at the beginning of the list' do
        expect(parent.children[0]).to eq(other_child)
      end
    end

    context 'when adding a child that already belongs to a parent' do
      let(:other_parent) { described_class.new }

      before do
        allow(other_parent).to receive(:abandon).and_call_original
        other_parent.adopt(child)
        parent.adopt(child)
      end

      it 'calls #abandon on the previous parent' do
        expect(other_parent).to have_received(:abandon).with(child)
      end
    end
  end

  describe '#abandon' do
    let(:child1) { described_class.new }
    let(:child2) { described_class.new }
    let(:child3) { described_class.new }
    let(:other_child) { described_class.new }

    before do
      parent.adopt(child3)
      parent.adopt(child2)
      parent.adopt(child1)
    end

    it 'does nothing if the caller attempts to remove a non-component child' do
      before_children = parent.children

      parent.abandon('not a component')

      expect(parent.children).to eq(before_children)
    end

    it 'does nothing if the caller does not already have the child' do
      before_children = parent.children

      parent.abandon(other_child)

      expect(parent.children).to eq(before_children)
    end

    context 'when removing a child that the parent has' do
      before do
        parent.abandon(child2)
      end

      it "removes the child from the parent's list of children" do
        expect(parent.children).not_to include(child2)
      end

      it "retains the other children in the parent's list" do
        expect(parent.children).to include(child1, child3)
      end

      it "sets the child's parent to nil" do
        expect(child2.parent).to eq(nil)
      end
    end
  end

  describe '#draw' do
    context 'when the component has three children' do
      let(:child1) { described_class.new }
      let(:child2) { described_class.new }
      let(:child3) { described_class.new }

      before do
        allow(child1).to receive(:_draw)
        allow(child2).to receive(:_draw)
        allow(child3).to receive(:_draw)

        parent.adopt(child3)
        parent.adopt(child2)
        parent.adopt(child1)

        parent.mark_as_dirty
        parent.draw
      end

      it 'calls the #_draw method for child 1' do
        expect(child1).to have_received(:_draw)
      end

      it 'calls the #_draw method for child 2' do
        expect(child2).to have_received(:_draw)
      end

      it 'calls the #_draw method for child 3' do
        expect(child3).to have_received(:_draw)
      end
    end
  end
end

RSpec.describe Gossamer::Gui::ParentComponent do
  it_behaves_like 'Component'
  it_behaves_like 'ParentComponent'
end
