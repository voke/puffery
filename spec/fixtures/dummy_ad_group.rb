Puffery.register :dummy do

  helper :price_in_cents do
    price*100
  end

  campaign_token :interplanetary_cruise
  ad_group_name 'Earth to Mars Cruises'

  ad do
    headline 'Luxury Cruise to Mars'
    description1 'Visit the Red Planet.'
    description2 "Low-gravity for only ¢#{price_in_cents}"
    display_url 'www.example.com'
    url 'http://www.example.com/mars'
  end

  # Defaults to BROAD match type
  keyword 'space hotel'

  keyword 'mars cruise' do
    match_type :phrase
  end

  keyword do
    text 'red planet'
    match_type :exact
  end

  keyword "mars #{name}"
  keyword 'meet martians' do
    url 'http://example.com/martians'
  end

end
