require 'singleton'
require 'net/http'
require 'openssl'
require 'cgi'

class Phonify::Api
  include Singleton
  attr_accessor :base_url, :api_key

  def initialize
    @base_url = ENV['PHONIFY_API_BASE_URL'] || "https://api.phonify.io"
    @api_key  = ENV['PHONIFY_API_KEY']
  end

  def broadcast(params)
    json_for request("/v1/campaigns/#{CGI.escape(params[:campaign_id])}/messages", params.except(:campaign_id), Net::HTTP::Post)
  end

  def create_message(params)
    json_for request("/v1/messages", params, Net::HTTP::Post)
  end

  def create_subscription(params)
    json_for request("/v1/subscriptions", params, Net::HTTP::Post)
  end

  def confirm_subscription(subscription_id)
    json_for request("/v1/subscriptions/#{CGI.escape(subscription_id)}/confirms")
  end

  def cancel_subscription(subscription_id)
    json_for request("/v1/subscriptions/#{CGI.escape(subscription_id)}/cancel")
  end

  def phone(phone_id)
    json_for request("/v1/phones/#{CGI.escape(phone_id)}")
  end

  def subscription(subscription_id)
    json_for request("/v1/subscriptions/#{CGI.escape(subscription_id)}")
  end

  def message(message_id)
    json_for request("/v1/messages/#{CGI.escape(message_id)}")
  end

  def request(url, params = {}, klass = Net::HTTP::Get, pem_filecontent = nil)
    uri = uri.kind_of?(URI::Generic) ? url : URI.join(base_url, url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      if pem_filecontent.blank?
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      else
        http.cert = OpenSSL::X509::Certificate.new(pem_filecontent)
        http.key = OpenSSL::PKey::RSA.new(pem_filecontent)
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
    end
    request = klass.new(uri.request_uri)
    request.basic_auth(api_key, '') if api_key.present?
    request.set_form_data(params.stringify_keys) unless params.blank?
    http.request(request)
  end

  def json_for(response)
    if response.code =~ /^2/
      JSON.parse(response.body).tap do |n|
        n.symbolize_keys! if n.respond_to?(:symbolize_keys!)
      end
    elsif response['location']
      json_for request(response['location'])
    else
      { error: response.code, reason: response.body }
    end
  end

end
