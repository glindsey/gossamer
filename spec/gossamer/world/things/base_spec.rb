# frozen_string_literal: true

require 'active_support/concern'

module Gossamer
  module World
    module Traits
      module TestingTrait
        extend ActiveSupport::Concern
        include World::Traits::HasProperties

        def self.included(mod)
          warn "#{self.inspect} included in #{mod.inspect}"
          mod.global_properties[:abstract] = false
          mod.global_properties[:testing] = true
        end

        def self.extended(mod)
          warn "#{self.inspect} extended in #{mod.inspect}"
          mod.local_properties[:abstract] = false
          mod.local_properties[:testing] = true
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
  subject(:thing) { described_class.new }

  it 'is marked as abstract' do
    expect(described_class.is?(:abstract)).to eq(true)
  end

  it 'can NOT be instantiated (because it is abstract)' do
    expect { thing }.to raise_error(RuntimeError)
  end

  context 'when provided a testing trait at instantiation' do
    subject(:thing) do
      described_class.new(
        traits: :testing_trait
      )
    end

    it 'can be instantiated' do
      expect { thing }.not_to raise_error
    end

    it 'is not marked as abstract' do
      expect(thing.is?(:abstract)).to eq(false)
    end

    it 'returns true when checked for the "testing" property' do
      expect(thing.is?(:testing)).to eq(true)
    end

    it 'returns false when checked for the "testing_property" property' do
      expect(thing.is?(:testing_property)).to eq(false)
    end
  end

  context 'when provided a testing trait and property at instantiation' do
    subject(:thing) do
      described_class.new(
        traits:     :testing_trait,
        properties: :testing_property
      )
    end

    it 'returns true when checked for the testing property' do
      expect(thing.is?(:testing_property)).to eq(true)
    end
  end

  context 'when provided a testing trait as part of a subclass' do
    subject(:thing) { ::Gossamer::World::Things::TestingClass.new }

    it 'can be instantiated' do
      expect { thing }.not_to raise_error
    end

    it 'is not marked as abstract' do
      expect(thing.is?(:abstract)).to eq(false)
    end

    it 'returns true when checked for the "testing" property' do
      expect(thing.is?(:testing)).to eq(true)
    end

    it 'returns false when checked for the "testing_property" property' do
      expect(thing.is?(:testing_property)).to eq(false)
    end
  end

  context 'when provided a testing trait as part of a subclass and a ' \
          'property at instantiation' do
    subject(:thing) do
      ::Gossamer::World::Things::TestingClass.new(
        properties: :testing_property
      )
    end

    it 'returns true when checked for the testing property' do
      expect(thing.is?(:testing_property)).to eq(true)
    end
  end
end
