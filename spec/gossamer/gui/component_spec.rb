# frozen_string_literal: true

RSpec.shared_examples('Component') do
  subject(:component) { described_class.new(width:, height:) }

  let(:width) { 10 }
  let(:height) { 20 }

  describe '.new' do
    it 'has a readable width' do
      expect(component.width).to eq(width)
    end

    it 'has a readable height' do
      expect(component.height).to eq(height)
    end

    it 'has no parent component' do
      expect(component.parent).to be_nil
    end
  end

  # This is NEVER allowed by any subclass of Component, it's too dangerous
  it "does not allow for explicit setting of the component's parent" do
    expect { component.parent = 'blah' }.to raise_error(NameError)
  end

  describe '#draw' do
    before do
      allow(component).to receive(:_draw).and_call_original
    end

    it 'does not draw if component is not marked dirty' do
      component.draw

      expect(component).not_to have_received(:_draw)
    end

    context 'when component is marked dirty' do
      before do
        component.mark_as_dirty
      end

      it 'draws the component' do
        component.draw

        expect(component).to have_received(:_draw)
      end

      it 'unmarks the component as dirty' do
        component.draw

        expect(component.dirty).to be(false)
      end
    end
  end

  describe '#mark_as_dirty' do
    it 'sets the dirty flag for the component' do
      component.mark_as_dirty

      expect(component.dirty).to be(true)
    end

    context 'when the component has a parent' do
      let(:parent) { described_class.new }

      before do
        allow(parent).to receive(:mark_as_dirty)

        component.instance_variable_set(:@parent, parent)
      end

      it 'calls #mark_as_dirty on the parent' do
        component.mark_as_dirty

        expect(parent).to have_received(:mark_as_dirty)
      end
    end
  end
end

RSpec.describe Gossamer::Gui::Component do
  it_behaves_like 'Component'
end
