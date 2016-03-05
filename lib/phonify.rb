require 'net/http'
require 'uri'
require 'json'

module Phonify
  class << self

    attr_accessor :api_key
   
    def send_subscription_message(app, phone, body, options = {})
      response = post('v1/messages', app: app, to: phone, body: body, free: options[:free])
      response ? response[:id] : false
    end

    def subscription_active?(app, phone)
      response = get('v1/subscriptions/active', app: app, to: phone)
      response ? response[:subscribed] : false
    end
    
    private

    def request(path, params)
      params[:api_key] = api_key
      response = yield("http://api.phonify.io/#{path}")
      JSON.parse(response.body, symbolize_names: true) if response and response.code == '200'
    end

    def post(path, params)
      request(path, params) { |url| Net::HTTP.post_form URI(url), params }
    end

    def get(path, params)
      request(path, params) { |url| Net::HTTP.get_response URI("#{url}?#{URI.encode_www_form(params.to_a)}") }
    end

  end
end
