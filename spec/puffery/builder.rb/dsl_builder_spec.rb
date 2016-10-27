require 'spec_helper'

describe Puffery::Builder::DslBuilder do

  describe '#_valid_attribute?' do

    let(:builder) { Puffery::Builder::DslBuilder.wrap(nil, [:foobar]) }

    it "returns true if valid" do
      builder._valid_attribute?('foobar').must_equal true
    end

    it 'returns false if not valid' do
      builder._valid_attribute?('barfoo').must_equal false
    end

  end

  describe '#_set_attribute' do

    it 'delegates to target object' do

      mock = MiniTest::Mock.new
      builder = Puffery::Builder::DslBuilder.wrap(mock, [:name],
        setter: 'write_attribute')

      mock.expect(:write_attribute, nil, [:name, 'foobar'])
      builder._set_attribute(:name, 'foobar')

    end

  end

end
