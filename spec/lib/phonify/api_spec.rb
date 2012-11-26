require 'spec_helper'

describe Phonify::Api do
  before(:each) do
    @http = mock "Http"
    @http.should_receive(:use_ssl=).with(true)
    @http.should_receive(:verify_mode=).with(0)
    Net::HTTP.stub!(:new) do |host,port|
      host.should == "api.phonify.io"
      port.should == 443
      @http
    end
  end
  describe '#broadcast' do
    it 'should call /v1/campaigns/{CAMPAIGN_ID}/messages' do
      attrs = { message: "this is sms", campaign_id: "camp-#{rand(100)}", schedule: 3.days.since.to_i }
      @http.should_receive(:request) do |req|
        req.method.should == 'POST'
        req.path.should == "/v1/campaigns/" + CGI.escape(attrs[:campaign_id]) + "/messages"
      end
      Phonify::Api.instance.broadcast(attrs)
    end
  end
  describe '#phone' do
    it 'should call /v1/phones/{PHONE_ID}' do
      attrs = { phone_id: "phone#{rand(999)}" }
      @http.should_receive(:request) do |req|
        req.method.should == 'GET'
        req.path.should == "/v1/phones/" + CGI.escape(attrs[:phone_id])
      end
      Phonify::Api.instance.phone(attrs)
    end
  end
  describe '#subscription' do
    it 'should call /v1/subscriptions/{PHONE_ID}' do
      attrs = { subscription_id: "subscription#{rand(999)}" }
      @http.should_receive(:request) do |req|
        req.method.should == 'GET'
        req.path.should == "/v1/subscriptions/" + CGI.escape(attrs[:subscription_id])
      end
      Phonify::Api.instance.subscription(attrs)
    end
  end
  describe '#message' do
    it 'should call /v1/messages/{PHONE_ID}' do
      attrs = { message_id: "message#{rand(999)}" }
      @http.should_receive(:request) do |req|
        req.method.should == 'GET'
        req.path.should == "/v1/messages/" + CGI.escape(attrs[:message_id])
      end
      Phonify::Api.instance.message(attrs)
    end
  end
end
