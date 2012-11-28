require 'spec_helper'

describe Phonify::Api do
  let(:response200) { mock "Response", code: "200", body: "[1,2,3]" }
  describe '#request' do
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
          req['authorization'].should == nil
          response200
        end
        Phonify::Api.instance.broadcast(attrs)
      end
    end
    describe '#phone' do
      it 'should call /v1/phones/{PHONE_ID}' do
        phone_id = "phone#{rand(999)}"
        @http.should_receive(:request) do |req|
          req.method.should == 'GET'
          req.path.should == "/v1/phones/" + CGI.escape(phone_id)
          req['authorization'].should == nil
          response200
        end
        Phonify::Api.instance.phone(phone_id)
      end
    end
    describe '#subscription' do
      it 'should call /v1/subscriptions/{PHONE_ID}' do
        subscription_id = "subscription#{rand(999)}"
        @http.should_receive(:request) do |req|
          req.method.should == 'GET'
          req.path.should == "/v1/subscriptions/" + CGI.escape(subscription_id)
          req['authorization'].should == nil
          response200
        end
        Phonify::Api.instance.subscription(subscription_id)
      end
    end
    describe '#message' do
      it 'should call /v1/messages/{PHONE_ID}' do
        message_id = "message#{rand(999)}"
        @http.should_receive(:request) do |req|
          req.method.should == 'GET'
          req.path.should == "/v1/messages/" + CGI.escape(message_id)
          req['authorization'].should == nil
          response200
        end
        Phonify::Api.instance.message(message_id)
      end
      it 'should set basic_auth when api_key is present' do
        message_id = "message#{rand(999)}"
        Phonify::Api.instance.stub!(:api_key).and_return('api_key')
        @http.should_receive(:request) do |req|
          req['authorization'].should == req.send(:basic_encode, 'api_key', '')
          response200
        end
        Phonify::Api.instance.message(message_id)
      end
    end
    describe '#create_message' do
      it 'should POST /v1/messages' do
        params = { campaign_id: "abc", message: "Hello world", sender: { id: "123" }, receiver: { id: "456 "} }
        @http.should_receive(:request) do |req|
          req.method.should == 'POST'
          req.path.should == '/v1/messages'
          req.body.should == URI.encode_www_form(params)
          response200
        end
        Phonify::Api.instance.create_message(params)
      end
    end
    describe '#create_subscription' do
      it 'should POST /v1/subscriptions' do
        params = { campaign_id: "abc", origin: { id: "123" }, service: { id: "456 "} }
        @http.should_receive(:request) do |req|
          req.method.should == 'POST'
          req.path.should == '/v1/subscriptions'
          req.body.should == URI.encode_www_form(params)
          response200
        end
        Phonify::Api.instance.create_subscription(params)
      end
    end
    describe '#confirm_subscription' do
      it 'should GET /v1/subscriptions/{SUBSCRIPTION_ID}/confirms' do
        some_id = '%04d' % rand(9999)
        @http.should_receive(:request) do |req|
          req.method.should == 'GET'
          req.path.should == '/v1/subscriptions/' + some_id + '/confirms'
          response200
        end
        Phonify::Api.instance.confirm_subscription(some_id)
      end
    end
    describe '#cancel_subscription' do
      it 'should GET /v1/subscriptions/{SUBSCRIPTION_ID}/cancel' do
        some_id = '%04d' % rand(9999)
        @http.should_receive(:request) do |req|
          req.method.should == 'GET'
          req.path.should == '/v1/subscriptions/' + some_id + '/cancel'
          response200
        end
        Phonify::Api.instance.cancel_subscription(some_id)
      end
    end
  end
  describe '#json_for' do
    let(:response301) { mock "Response", code: "301", :[] => 'http://yahoo.com/'}
    let(:response404) { mock "Response", code: "404", :[] => nil, body: "Blah #{rand(999)} Not Found" }
    let(:response500) { mock "Response", code: "500", :[] => nil, body: "Error #{rand(999)}" }
    it 'should return parsed JSON when successful' do
      Phonify::Api.instance.json_for(response200).should == [1,2,3]
    end
    it 'should follow redirect' do
      @http = mock "Http"
      @http.should_receive(:request).and_return(response200)
      Net::HTTP.stub!(:new) do |host,port|
        host.should == "yahoo.com"
        port.should == 80
        @http
      end
      Phonify::Api.instance.json_for(response301).should == [1,2,3]
    end
    it 'should return error JSON otherwise' do
      Phonify::Api.instance.json_for(response404).should == { error: "404", reason: response404.body }
      Phonify::Api.instance.json_for(response500).should == { error: "500", reason: response500.body }
    end
  end
end
