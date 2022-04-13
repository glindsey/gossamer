# frozen_string_literal: true

require 'active_support/concern'

module Gossamer
  module World
    module Traits
      module TestingTrait
        extend World::Traits::Base
        include World::Traits::HasProperties

        class_methods do
          def abstract?
            false
          end

          def testing?
            true
          end
        end
      end
    end
  end
end

module Gossamer
  module World
    module Things
      class TestingClass < Base
        include ::Gossamer::World::Traits::TestingTrait
      end
    end
  end
end

RSpec.describe Gossamer::World::Things::Base do
  subject(:thing) { described_class.new(nil, pool: nil) }

  it 'is marked as abstract' do
    expect(described_class.is?(:abstract)).to be(true)
  end

  it 'can NOT be instantiated (because it is abstract)' do
    expect { thing }.to raise_error(RuntimeError)
  end

  context 'when provided a testing trait as part of a subclass' do
    subject(:thing) do
      ::Gossamer::World::Things::TestingClass.new(nil, pool: nil)
    end

    it 'can be instantiated' do
      expect { thing }.not_to raise_error
    end

    it 'is not marked as abstract' do
      expect(thing.is?(:abstract)).to be(false)
    end

    it 'returns true when checked for the "testing" property' do
      expect(thing.is?(:testing)).to be(true)
    end

    it 'returns false when checked for the "testing_property" property' do
      expect(thing.is?(:testing_property)).to be(false)
    end
  end

  context 'when provided a testing trait as part of a subclass and a ' \
          'property at instantiation' do
    subject(:thing) do
      ::Gossamer::World::Things::TestingClass.new(
        nil, pool:       nil,
             properties: :testing_property
      )
    end

    it 'returns true when checked for the testing property' do
      expect(thing.is?(:testing_property)).to be(true)
    end
  end
end
