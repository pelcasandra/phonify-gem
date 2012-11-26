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
          response200
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
          response200
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
          response200
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
          response200
        end
        Phonify::Api.instance.message(attrs)
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
