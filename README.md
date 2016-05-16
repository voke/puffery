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
  config.debug = false
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

  keyword 'mars %{name}'
  keyword 'meet martians', url: 'http://example.com/martians'

end
```

### Basic Model

```ruby
class Product < ActiveRecord::Base

  include Puffery::Model

  # This is the default method to determine if the
  # ad group should be enabled or paused.
  def advertise?
    self.price > 100
  end

end
```

Just call `Product.find(1).sync_ads` to push ad group, ads and keywords to remote server

### Advanced Model

Sometimes it's better to use a polymorphic model to store data about the ad groups. In that case, we need to configure some options.

```ruby
class AdGroup < ActiveRecord::Base

  include Puffery::Model

  puffery namespace: -> x { x.advertisable_type.parameterize }, subject: :advertisable

  belongs_to :advertisable, polymorphic: true

  def advertise?
    advertisable.should_advertise?
  end

end
```

The `puffery()` class method supports options for `:namespace`, `:subject` and `:valid`.

| Name      | Default                  | Comment                                                                                                                                                   |
|-----------|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| namespace | self.class.name.downcase | The corresponding name for the schema                                                                                                                     |
| subject   | self                     | The object used when building payload from schema                                                                                                         |
| valid     | :advertise?              | The method puffery calls to determine if it should enable or pause the ad group. The argument can be either a :symbol (method), block or any other value. |

## Contributing

1. Fork it ( https://github.com/[my-github-username]/puffery/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
