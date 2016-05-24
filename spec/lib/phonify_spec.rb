require 'spec_helper'
#require 'pry'

describe Phonify do
  let(:app) { 'app' }
  let(:phone) { 'phone' }
  let(:api_key) { 'api_key' }
  let(:authentication_token) { '1234567890' }
  let(:code) { 'code' }
  let(:id) { '10' }
  let(:limit) { '5' }
  let(:offset) { '5' }
  let(:params) { nil }
  let(:action) { 'get_response' }  

  before do
    Phonify.api_key = api_key
    Phonify.app = app
    Net::HTTP.stub(action).and_return(response)
  end

  describe 'Messages' do
    let(:response) { mock(code: '200', body: { message: { id: id } }.to_json) }
    
    describe '#send_message' do
      let(:body) { 'body' }
      let(:action) { 'post_form' }

      before { Net::HTTP.should_receive(action).with(URI('https://api.phonify.io/v1/messages'), app: app, to: phone, body: body, api_key: api_key) }

      it { expect(Phonify.send_message(phone, body)[:message][:id]).to eq('10') }
    end

    describe '#find_message' do
      before { Net::HTTP.should_receive(action).with(URI("https://api.phonify.io/v1/messages/#{id}?api_key=#{api_key}&app=#{app}")) }

      it { expect(Phonify.find_message(id)[:message][:id]).to eq('10') }
    end

    describe '#messages' do
      let(:messages) { [{ id: id }, { id: id }] }
      let(:response) { mock(code: '200', body: { messages: messages }.to_json) } 

      before { Net::HTTP.should_receive(action).with(URI("https://api.phonify.io/v1/messages?limit=#{limit}&offset=#{offset}&api_key=#{api_key}&app=#{app}")) }

      it { expect(Phonify.messages(limit: limit, offset: offset)[:messages]).to match_array(messages) }
    end
  end

  describe 'Phones' do
    let(:response) { mock(code: '200', body: { phone: { id: id } }.to_json) } 

    describe '#find_phone' do
      before { Net::HTTP.should_receive(action).with(URI("https://api.phonify.io/v1/subscriptions/#{id}?api_key=#{api_key}&app=#{app}")) }

      it { expect(Phonify.find_phone(id)[:phone][:id]).to eq('10') }
    end

    describe '#phones' do
      let(:phones) { [{ id: id }, { id: id }] }
      let(:response) { mock(code: '200', body: { phones: phones }.to_json) } 

      before { Net::HTTP.should_receive(action).with(URI("https://api.phonify.io/v1/subscriptions?limit=#{limit}&offset=#{offset}&api_key=#{api_key}&app=#{app}")) }

      it { expect(Phonify.phones(limit: limit, offset: offset)[:phones]).to match_array(phones) }
    end 
  end

  describe 'Verify' do
    let(:action) { 'post_form' }

    describe '#verify' do
      let(:response) { mock(code: '200', body: { authentication_token: authentication_token, state: 'verified', code: code }.to_json) }

      before { Net::HTTP.should_receive(action).with(URI('https://api.phonify.io/v1/verify'), app: app, msisdn: phone, code: code, api_key: api_key) }

      it { expect(Phonify.verify(phone, code)[:authentication_token]).to eq(authentication_token) }
    end  

    describe '#authenticate' do
      let(:response) { mock(code: '200', body: { authentication_token: authentication_token, state: 'subscribed' }.to_json) }

      before { Net::HTTP.should_receive(action).with(URI('https://api.phonify.io/v1/authenticate'), app: app, authentication_token: authentication_token, api_key: api_key) }

      it { expect(Phonify.authenticate(authentication_token)[:authentication_token]).to eq(authentication_token) }
    end
  end
end