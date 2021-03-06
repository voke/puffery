require 'excon'
require 'json'

module Puffery
  class Client

    USER_AGENT = "Puffery Ruby #{Puffery::VERSION}"
    RequestError = Class.new(StandardError)
    ResourceNotFoundError = Class.new(RequestError)

    STATUS_ENABLED = 'enabled'
    STATUS_PASUED = 'paused'

    attr_accessor :url, :key

    def initialize(url = nil, key = nil)
      self.url = url || Puffery.configuration.api_url || raise('Missing Api URL')
      self.key = key || Puffery.configuration.api_key || raise('Missing Api key')
    end

    def conn
      @conn ||= Excon.new(self.url, debug: Puffery.debug?, headers:
        { 'Content-Type' => 'application/json', 'X-API-KEY' => key })
    end

    def push(uid, payload, active:)
      payload[:ad_group][:status] = active ? STATUS_ENABLED : STATUS_PASUED
      json = if uid
        request(:put, "/api/ad_groups/#{uid}", payload)
      else
        request(:post, '/api/ad_groups', payload)
      end
      json['ad_group']
    end

    def down(uid, attrs = { status: STATUS_PASUED })
      json = request(:patch, "/api/ad_groups/#{uid}", attrs)
      json['ad_group']
    end

    def unlink(uid)
      json = request(:delete, "/api/ad_groups/#{uid}")
      json['ad_group']['deleted_at']
    end

    def request(method, path, body = {})
      res = conn.request(method: method, path: path, body: JSON.dump(body))
      json = JSON.parse(res.body)
      handle_errors(json)
      json
    end

    def handle_errors(data)
      if data['errors'].any?
        if data['code'] == 404
          raise ResourceNotFoundError, data['errors'].first
        else
          raise RequestError,
            "Request Error occurred: %s" % data['errors'].first
        end
      end
    end

  end
end
