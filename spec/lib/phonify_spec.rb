require 'spec_helper'
require 'pry'

describe Phonify do
  let(:app) { 'app' }
  let(:phone) { 'phone' }
  let(:api_key) { 'api_key' }
  let(:authentication_token) { '1234567890' }
  let(:code) { 'code' }
  let(:id) { '10' }  

  before do
    Phonify.api_key = api_key
    Phonify.app = app
  end

  context 'messages' do
    let(:response) { mock(code: '200', body: { message: { id: id } }.to_json) } 
    
    describe '#send_message' do
      let(:body) { 'body' }

      it 'call post_form with the appropiate parameters' do
        Net::HTTP.stub('post_form').and_return(response)
        Net::HTTP.should_receive('post_form').with(URI('http://api.phonify.io/v1/messages'), app: app, to: phone, body: body, free: nil, api_key: api_key)
        expect(Phonify.send_message(phone, body)[:message][:id]).to eq('10')
      end
    end

    describe '#find_message' do
      it "call get_response with the appropriate parameters" do
        Net::HTTP.stub('get_response').and_return(response)
        Net::HTTP.should_receive('get_response').with(URI("http://api.phonify.io/v1/messages/#{id}?api_key=#{api_key}&app=#{app}"))
        expect(Phonify.find_message(id)[:message][:id]).to eq('10')
      end
    end

    describe '#messages', focus: true do
      let(:messages) { [{ id: id }, { id: id }] }
      let(:response) { mock(code: '200', body: { messages: messages }.to_json) } 

      it "call get_response with the appropriate parameters" do
        Net::HTTP.stub('get_response').and_return(response)
        Net::HTTP.should_receive('get_response').with(URI("http://api.phonify.io/v1/messages?offset&limit&api_key=#{api_key}&app=#{app}"))
        expect(Phonify.messages[:messages]).to match_array(messages)
      end
    end
  end  

  # describe '#subscription_active?' do
  #   let(:response) { mock(code: '200', body: { subscribed: true }.to_json) }

  #   it "call get_response with the appropriate parameters" do
  #     Net::HTTP.stub('get_response').and_return(response)
  #     Net::HTTP.should_receive('get_response').with(URI("http://api.phonify.io/v1/subscriptions/active?app=#{app}&to=#{phone}&api_key=#{api_key}"))
  #     expect(Phonify.subscription_active?(app, phone)).to eq(true)
  #   end
  # end

  describe '#verify' do
    let(:response) { mock(code: '200', body: { authentication_token: authentication_token, state: 'verified', code: code }.to_json) }

    it "call get_response with the appropriate parameters" do
      Net::HTTP.stub('post_form').and_return(response)
      Net::HTTP.should_receive('post_form').with(URI('http://api.phonify.io/v1/verify'), app: app, msisdn: phone, code: code, api_key: api_key)
      expect(Phonify.verify(phone, code)[:authentication_token]).to eq(authentication_token)
    end
  end  

  describe '#authenticate' do
    let(:response) { mock(code: '200', body: { authentication_token: authentication_token, state: 'subscribed' }.to_json) }

    it "call get_response with the appropriate parameters" do
      Net::HTTP.stub('post_form').and_return(response)
      Net::HTTP.should_receive('post_form').with(URI('http://api.phonify.io/v1/authenticate'), app: app, auth_token: authentication_token, api_key: api_key)
      expect(Phonify.authenticate(authentication_token)[:authentication_token]).to eq(authentication_token)
    end
  end
end