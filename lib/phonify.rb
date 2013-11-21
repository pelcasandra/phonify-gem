require 'net/http'
require 'uri'

module Phonify

  attr_accessor :token

  def send_subscription_message(shortcode, phone, keyword, body)
    post 'v1/subscriptions/messages', shortcode: shortcode, phone: phone, keyword: keyword, body: body
  end

  def subscription_active?(shortcode, phone, keyword)
    get 'v1/subscriptions/active', shortcode: shortcode, phone: phone, keyword: keyword
  end
  
  private

  def request(path, params)
    params[:token] = token
    url = "http://api.phonify.io/#{path}"
    if response = yield(url) and response.code == '200'
      body = JSON.parse(response.body)
      puts url, params, body if Rails.env.development?
      body
    end
  end

  def post(path, params)
    request(path, params) { |url| Net::HTTP.post_form URI(url), params }
  end

  def get(path, params)
    request(path, params) { |url| Net::HTTP.get_response URI("#{url}?#{params.to_query}") }
  end

end
