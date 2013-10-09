require 'spec_helper'

describe Phonify::Api do
  let(:response200) { mock "Response", :code => "200", :body => "[1,2,3]" }
  describe '#request' do
    before(:each) do
      uri = URI.parse(Phonify::Api.instance.base_url)
      @http = mock "Http"
      if uri.scheme == 'https'
        @http.should_receive(:use_ssl=).with(true)
        @http.should_receive(:verify_mode=).with(0)
      end
      Net::HTTP.stub!(:new) do |host,port|
        host.should == uri.host
        port.should == uri.port
        @http
      end
    end
    describe '#broadcast' do
      it 'should call /v1/apps/{APP_ID}/messages' do
        attrs = { :message => "this is sms", :app_id => "app-#{rand(100)}", :schedule => 3.days.since.to_i }
        @http.should_receive(:request) do |req|
          req.method.should == 'POST'
          req.path.should == "/v1/apps/" + CGI.escape(attrs[:app_id]) + "/messages"
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
        params = { :app_id => "abc", :message => "Hello world", :origin => { :id => "123" }, :destination => [{ :id => "456 "}] }
        @http.should_receive(:request) do |req|
          req.method.should == 'POST'
          req.path.should == '/v1/messages'
          req.body.should == Phonify::Api.send(:new).params2query(params)
          response200
        end
        Phonify::Api.instance.create_message(params)
      end
    end
    describe '#create_subscription' do
      it 'should POST /v1/subscriptions' do
        params = { :app_id => "abc", :origin => { :id => "123" }, :service => { :id => "456 "} }
        @http.should_receive(:request) do |req|
          req.method.should == 'POST'
          req.path.should == '/v1/subscriptions'
          req.body.should == Phonify::Api.send(:new).params2query(params)
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
    describe '#subscriptions' do
      it 'should GET /v1/subscriptions' do
        params = { :app_id => "app123" }
        @http.should_receive(:request) do |req|
          req.method.should == 'GET'
          req.path.should == '/v1/subscriptions?' + Phonify::Api.send(:new).params2query(params)
          response200
        end
        Phonify::Api.instance.subscriptions(params)
      end
    end
  end
  describe '#json_for' do
    let(:response301) { mock "Response", :code => "301", :[] => 'http://yahoo.com/'}
    let(:response404) { mock "Response", :code => "404", :[] => nil, :body => {errors: [{ type: "not_found", title: "Blah #{rand(999)} Not Found"}]}.to_json }
    let(:response500) { mock "Response", :code => "500", :[] => nil, :body => {errors: [{ type: "not_found", title: "Error #{rand(999)}"}]}.to_json }
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
      begin
        Phonify::Api.instance.json_for(response404).should == "have raised error, and not reach here"
      rescue Phonify::Exception
        $!.message.should == response404.body
      end
      begin
        Phonify::Api.instance.json_for(response500).should == "have raised error, and not reach here"
      rescue Phonify::Exception
        $!.message.should == response500.body
      end
    end
  end
  describe '#params2query' do
    it 'should encode Hash like URI.encode_www_form' do
      hash = { :key => 123, :email => "lorem+ipsum@example.com"}
      Phonify::Api.instance.params2query(hash).should == URI.encode_www_form(hash)
    end
    it 'should flatten deep hash into parent[child]=value key pairs' do
      hash = { :key => { :email => "lorem+ipsum@example.com" } }
      Phonify::Api.instance.params2query(hash).should == URI.encode_www_form('key[email]' => "lorem+ipsum@example.com")
    end
    it 'should repeat arrays with key[]=value1&key[]=value2 etc' do
      hash = { :emails => ["ipsum@example.com","lorem@example.com"] }
      Phonify::Api.instance.params2query(hash).should == URI.encode_www_form("emails[]"=>"ipsum@example.com") + '&' + URI.encode_www_form("emails[]"=>"lorem@example.com")
    end
  end
  describe '#deep_symbolize_keys!' do
    it 'should make all Hash keys as symbols' do
      value = [1, 2, { "key1" => { "key2" => true }, :key3 => false }]
      Phonify::Api.instance.deep_symbolize_keys!(value).should == [1, 2, {:key1=>{:key2=>true}, :key3=>false}]
    end
  end
end
