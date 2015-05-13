require 'spec_helper'

describe Keyword do

  describe '#initialize' do

    it "sets default match type" do
      keyword = Keyword.new
      keyword.match_type.must_equal 'BROAD'
    end

  end

end
