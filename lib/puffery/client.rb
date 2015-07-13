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

    def up(resource)
      payload = Puffery.build_payload(resource)
      payload[:ad_group][:status] = 'enabled'
      uid = resource.remote_uid
      raise 'Missing UID' unless uid
      response = conn.put(path: "/api/ad_groups/#{resource.remote_uid}",
        body: JSON.dump(payload)
      )
      handle_errors(response)
      response
    end

    def handle_errors(response)
      data = JSON.parse(response.body)
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
