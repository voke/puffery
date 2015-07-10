# Puffery

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'puffery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puffery

## Usage

#### Configuration

This file is usually located at `/config/initializers/puffery.rb`.

```ruby
Puffery.configure do |config|
  config.api_url = "https://example.com"
  config.api_key = "secret"
end
```

#### DSL

```ruby
Puffery.register :product do

  helper :price_in_cents do
    price*100
  end

  campaign_token :interplanetary_cruise
  ad_group_name 'Earth to Mars Cruises'

  ad do
    headline 'Luxury Cruise to Mars'
    description1 'Visit the Red Planet.'
    description2 'Low-gravity for only ¢%{price_in_cents}'
    final_urls ['http://www.example.com/mars']
    display_url 'www.example.com'
  end

  keyword 'space hotel'

  keyword 'mars cruise' do
    match_type :phrase
  end

  keyword do
    text 'red planet'
    match_type :exact
  end

  keyword 'mars %{name}'
  keyword 'meet martians', final_urls: ['http://example.com/martians']

end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/puffery/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
