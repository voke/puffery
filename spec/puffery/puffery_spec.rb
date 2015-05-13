require 'spec_helper'

describe Puffery do

  describe '#configure' do

    it "returns instance of configuration" do
      Puffery.configure do |config|
        config.must_be_instance_of(Puffery::Configuration)
      end
    end

  end

end
