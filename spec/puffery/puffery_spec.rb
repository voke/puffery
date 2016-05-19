require 'spec_helper'

describe Puffery do

  describe '#configure' do

    it "returns instance of configuration" do
      Puffery.configure do |config|
        config.must_be_instance_of(Puffery::Configuration)
      end
    end

  end

  describe '#load_files' do

    it 'runs only once' do
      Puffery.expects(:files_in_load_path).times(1).returns([])
      2.times do
        Puffery.load_files
      end
    end

  end

end
