require 'net/http'
require 'uri'
require 'json'

module Phonify
  class << self
   
    def send_message(msisdn, body, options = {})
      post('v1/messages', { to: msisdn, body: body }.merge(options))
    end

    def message(id)
      get("v1/messages/#{id}")
    end

    def messages(options = {})
      get('v1/messages', options)
    end

    def phone(msisdn)
      get("v1/phones/#{msisdn}")
    end

    def phones(options = {})
      get('v1/phones', options)
    end

    def verify(msisdn, code = nil)
      post('v1/verify', msisdn: msisdn, code: code)
    end

    def authenticate(authentication_token)
      post('v1/authenticate', authentication_token: authentication_token)
    end

    def unsubscribe(msisdn)
      post("v1/phones/#{msisdn}/unsubscribe")
    end
    
    private

    def request(path, params)
      params[:api_key] = Phonify.configuration.api_key
      params[:app] = Phonify.configuration.app
      response = yield("https://www.phonify.io/#{path}")
      JSON.parse(response.body, symbolize_names: true) if response
    end

    def post(path, params = {})
      request(path, params) { |url| Net::HTTP.post_form URI(url), params }
    end

    def get(path, params = {})
      request(path, params) { |url| Net::HTTP.get_response URI("#{url}?#{URI.encode_www_form(params.to_a)}") }
    end
  end

  class Configuration
    attr_accessor :api_key, :app
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end  
end