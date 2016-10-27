require 'spec_helper'

describe Puffery do

  describe '#configure' do

    it "returns instance of configuration" do
      Puffery.configure do |config|
        config.must_be_instance_of(Puffery::Configuration)
      end
    end

  end

  describe 'full parsing' do

    it 'returns payload' do

      dummy_obj = OpenStruct.new
      dummy_obj.name = 'Beginner Mars Cruise'
      dummy_obj.price = 5

      output = Puffery.build_payload(dummy_obj, 'dummy')

      output.must_equal({
        ad_group: {
          name: 'Earth to Mars Cruises',
          campaign_token: "interplanetary_cruise"
        },
        keywords: [
          { match_type: "broad", text: "space hotel" },
          { match_type: "broad", text: "mars cruise" },
          { match_type: "broad", text: "red planet" },
          { match_type: "broad", text: "mars beginner mars cruise" },
          { match_type: "broad", text: "meet martians", url: "http://example.com/martians" }
        ],
        ads: [{
            headline: 'Luxury Cruise to Mars',
            description1: 'Visit the Red Planet.',
            description2: 'Low-gravity for only ¢500',
            display_url: 'www.example.com',
            url: 'http://www.example.com/mars'
        }]
      })

    end

  end

end
