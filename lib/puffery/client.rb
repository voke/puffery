require 'excon'
require 'json'

module Puffery
  class Client

    USER_AGENT = "Puffery Ruby #{Puffery::VERSION}"
    RequestError = Class.new(StandardError)

    attr_accessor :url, :key

    def initialize(url = nil, key = nil)
      self.url = url || Puffery.configuration.api_url || raise('Missing Api URL')
      self.key = key || Puffery.configuration.api_key || raise('Missing Api key')
    end

    def auth_header
      "Token token='#{key}'"
    end

    def conn
      @conn ||= Excon.new(self.url, debug: true, headers:
        { 'Content-Type' => 'application/json' })
    end

    def up(uid, payload)
      json = request(:put, "/api/ad_groups/#{uid}", payload.raw)
      json['ad_group']
    end

    def down(uid)
      json = request(:patch, "/api/ad_groups/#{uid}", { status: 'paused' })
      json['ad_group']
    end

    def request(method, path, body = {})
      res = conn.request(method: method, path: path, body: JSON.dump(body))
      json = JSON.parse(res.body)
      handle_errors(json)
      json
    end

    def handle_errors(data)
      if data['errors'].any?
        raise RequestError,
          "Request Error occurred: %s" % data['errors'].first
      end
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
