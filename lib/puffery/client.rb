module Puffery
  class Client

    USER_AGENT = "Puffery Ruby #{Puffery::VERSION}"

    attr_accessor :url, :key

    def initialize(url = nil, key = nil)
      self.url = url || Puffery.configuration.api_url || raise('Missing Api URL')
      self.key = key || Puffery.configuration.api_key || raise('Missing Api key')
    end

    def auth_header
      "Token token='#{key}'"
    end

    def conn
      @conn = Excon.new(self.url, debug: true,
        headers: { 'Authorization' => auth_header })
    end

    # Update partial resources
    def patch(payload)
    end
    
    # PUT request replace whole object
    # PUTting the same data multiple times to the same resource
    # should not result in different resources
    def put(payload)

    end

  end
end
