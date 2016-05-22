require 'net/http'
require 'uri'
require 'json'

module Phonify
  class << self

    attr_accessor :api_key, :app
   
    def send_message(phone, body, options = {})
      post('v1/messages', to: phone, body: body, free: options[:free])
    end

    def find_message(id)
      post('v1/messages', id: id)
    end

    def messages(options = {})
      post('v1/messages', offset: options[:offset], limit: options[:limit])
    end

    def find_phone(id)
      get('v1/subscriptions/', to: phone)
    end

    def phones(id)
      get('v1/subscriptions/', to: phone)
    end

    def verify(phone, code = nil)
      post('v1/verify', msisdn: phone, code: code)
    end

    def authenticate(auth_token)
      post('v1/authenticate', auth_token: auth_token)
    end

    def cancel(id)
      get('v1/cancel/', to: phone)
    end
    
    private

    def request(path, params)
      params[:api_key] = api_key
      params[:app] = app
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