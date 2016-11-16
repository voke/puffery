require 'spec_helper'

describe Puffery::Builder::AdGroup do

  describe '#keyword' do

    it 'sets and add keywords' do

      ad_group = Puffery::Builder::AdGroup.new('')
      ad_group.keyword('foobar')

      ad_group.keywords.size.must_equal 1
      ad_group.keywords.first.text.must_equal 'foobar'

    end

  end

end
