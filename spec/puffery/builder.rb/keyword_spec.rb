require 'spec_helper'

describe Puffery::Builder::Keyword do

  describe '#initialize' do

    it "sets default match type" do
      keyword = Puffery::Builder::Keyword.new('')
      keyword.match_type.must_equal 'broad'
    end

  end

end
