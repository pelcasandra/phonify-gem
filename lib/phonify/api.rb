require 'singleton'
require 'net/http'
require 'openssl'
require 'cgi'

class Phonify::Api
  include Singleton
  attr_accessor :base_url

  def initialize
    @base_url = ENV['PHONIFY_API_BASE_URL'] || "https://api.phonify.io"
  end

  def broadcast(params)
    json_for request("/v1/campaigns/#{CGI.escape(params[:campaign_id])}/messages", params.except(:campaign_id), Net::HTTP::Post)
  end

  def phone(params)
    json_for request("/v1/phones/#{CGI.escape(params[:phone_id])}", params.except(:phone_id))
  end

  def subscription(params)
    json_for request("/v1/subscriptions/#{CGI.escape(params[:subscription_id])}", params.except(:subscription_id))
  end

  def message(params)
    json_for request("/v1/messages/#{CGI.escape(params[:message_id])}", params.except(:message_id))
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
    request.set_form_data(params.stringify_keys) unless params.blank?
    http.request(request)
  end

  def json_for(response)
    if response.code =~ /^2/
      JSON.parse(response.body)
    elsif response['location']
      json_for request(response['location'])
    else
      { error: response.code, reason: response.body }
    end
  end

end
