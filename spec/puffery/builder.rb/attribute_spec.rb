require 'spec_helper'

describe Puffery::Builder::Attribute do

  describe '#sanitized' do

    it 'returns sanitized version of string' do
      attribute = Puffery::Builder::Attribute.new("Compare {KeyWord:Our Price}", nil)
      attribute.sanitized.must_equal 'Compare Our Price'
    end

  end

  describe '#valid_length?' do

    it 'returns false when length > max_chars' do
      attribute = Puffery::Builder::Attribute.new('123456789', nil,
        max_chars: 8)
      attribute.max_chars.must_equal 8
      attribute.valid_length?.must_equal false
    end

  end

end
