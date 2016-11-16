require 'spec_helper'

class DummyClass < Puffery::Builder::Base
  attribute :text
  attribute :desc
end

describe Puffery::Builder::Base do

  describe '.attribute' do

    it 'defines reader and setter methods' do
      dummy = DummyClass.new(nil)
      dummy.respond_to?('text').must_equal true
      dummy.respond_to?('text=').must_equal true
    end

  end

  describe '#eval_dsl_block' do

    it 'raises if no block given' do
      proc {
        dummy = DummyClass.new(nil)
        dummy.eval_dsl_block
      }.must_raise(Puffery::Builder::Base::NoBlockGivenError)
    end

  end

  describe '.attributes' do

    it 'returns AttributeSet' do
      Puffery::Builder::Base.attributes
        .must_be_instance_of Puffery::Builder::AttributeSet
    end

  end

  describe '.attribute_names' do

    it 'returns Array for names' do
      DummyClass.attribute_names.must_equal [:text, :desc]
    end

  end

  describe '#write_attribute' do

    it 'returns attribute value' do
      dummy = DummyClass.new(nil)
      dummy.write_attribute(:text, 'foobar')
      dummy.text.must_equal 'foobar'
    end

  end

  describe '#read_attribute' do

    it 'reads attribute value' do
      dummy = DummyClass.new(nil)
      dummy.read_attribute(:text).must_equal nil
      dummy.write_attribute(:text, 'hello')
      dummy.read_attribute(:text).must_equal 'hello'
    end

  end

end
