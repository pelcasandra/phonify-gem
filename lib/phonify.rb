require 'net/http'
require 'uri'
require 'json'

module Phonify

  REPOSITORY_URL = 'https://github.com/pelcasandra/phonify-gem/blob/master/README.md'

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

    def subscription(id)
      get("v1/subscriptions/#{id}")
    end

    def subscriptions(options = {})
      get('v1/subscriptions', options)
    end    

    def unsubscribe(msisdn)
      post("v1/subscriptions/#{msisdn}/unsubscribe")
    end
    
    private

    def request(path, params)
      params[:api_key] = Phonify.configuration.api_key
      params[:business] = Phonify.configuration.business
      warn "Warning: Phonify: API key was not supplied. Check #{REPOSITORY_URL} for help." if Phonify.configuration.api_key.nil?
      warn "Warning: Phonify: Business name was not supplied. Check #{REPOSITORY_URL} for help." if Phonify.configuration.business.nil?
      response = yield("https://www.phonify.io/#{path}") if block_given?
      begin
        JSON.parse(response.body, symbolize_names: true)
      rescue JSON::ParserError
        puts "#{api_error(response)}"
        api_error(response)
      end
    end

    def post(path, params = {})
      request(path, params) { |url| Net::HTTP.post_form URI(url), params }
    end

    def get(path, params = {})
      request(path, params) { |url| Net::HTTP.get_response URI("#{url}?#{URI.encode_www_form(params.to_a)}") }
    end

    def api_error(response)
      {:error => response.error_type.to_s, :status => response.code }
    end
  end

  class Configuration
    attr_accessor :api_key, :business
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