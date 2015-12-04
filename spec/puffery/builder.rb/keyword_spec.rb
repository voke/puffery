require 'spec_helper'

describe Puffery::Builder::Keyword do

  describe '#initialize' do

    it "sets default match type" do
      keyword = Puffery::Builder::Keyword.new('')
      keyword.match_type.must_equal 'broad'
    end

  end

  describe '.normalize' do

    it 'return lowercase version of text' do
      result = Puffery::Builder::Keyword.normalize('SMÖRGÅS bord')
      result.must_equal 'smörgås bord'
    end

  end

  describe '.filter_invalid_chars' do

    it 'return string without invalid chars' do
      string = ",!@%^*()={};~`´’<>?\|®™²»–"
      Puffery::Builder::Keyword.filter_invalid_chars(string).must_equal('')
    end

  end

end
