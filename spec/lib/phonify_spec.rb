require 'spec_helper'

describe Phonify do
  let(:msisdn) { '+14560000000' }
  let(:business) { 'business' }
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
    Phonify.configure do |config|
      config.api_key = api_key
      config.business = business          
    end
    Net::HTTP.stub(action).and_return(response)
  end

  describe 'Messages' do
    let(:response) { double(code: '200', body: { message: { id: id } }.to_json) }
    
    describe '#send_message' do
      let(:body) { 'body' }
      let(:action) { 'post_form' }

      before { Net::HTTP.should_receive(action).with(URI('https://www.phonify.io/v1/messages'), business: business, to: phone, body: body, api_key: api_key) }

      it { expect(Phonify.send_message(phone, body)[:message][:id]).to eq(id) }
    end

    describe '#message' do
      before { Net::HTTP.should_receive(action).with(URI("https://www.phonify.io/v1/messages/#{id}?api_key=#{api_key}&business=#{business}")) }

      it { expect(Phonify.message(id)[:message][:id]).to eq('10') }
    end

    describe '#messages' do
      let(:messages) { [{ id: id }, { id: id }] }
      let(:response) { double(code: '200', body: { messages: messages }.to_json) } 

      before { Net::HTTP.should_receive(action).with(URI("https://www.phonify.io/v1/messages?limit=#{limit}&offset=#{offset}&api_key=#{api_key}&business=#{business}")) }

      it { expect(Phonify.messages(limit: limit, offset: offset)[:messages]).to match_array(messages) }
    end
  end

  describe 'Phones' do
    let(:response) { double(code: '200', body: { phone: { id: id } }.to_json) } 

    describe '#phone' do
      before { Net::HTTP.should_receive(action).with(URI("https://www.phonify.io/v1/phones/#{msisdn}?api_key=#{api_key}&business=#{business}")) }

      it { expect(Phonify.phone(msisdn)[:phone][:id]).to eq('10') }
    end

    describe '#phones' do
      let(:phones) { [{ id: id }, { id: id }] }
      let(:response) { double(code: '200', body: { phones: phones }.to_json) } 

      before { Net::HTTP.should_receive(action).with(URI("https://www.phonify.io/v1/phones?limit=#{limit}&offset=#{offset}&api_key=#{api_key}&business=#{business}")) }

      it { expect(Phonify.phones(limit: limit, offset: offset)[:phones]).to match_array(phones) }
    end
  end  

  describe 'Subscriptions' do
    let(:response) { double(code: '200', body: { subscription: { id: id } }.to_json) } 

    describe '#subscription' do
      before { Net::HTTP.should_receive(action).with(URI("https://www.phonify.io/v1/subscriptions/#{id}?api_key=#{api_key}&business=#{business}")) }

      it { expect(Phonify.subscription(id)[:subscription][:id]).to eq(id) }
    end

    describe '#subscriptions' do
      let(:subscriptions) { [{ id: id }, { id: id }] }
      let(:response) { double(code: '200', body: { subscriptions: subscriptions }.to_json) } 

      before { Net::HTTP.should_receive(action).with(URI("https://www.phonify.io/v1/subscriptions?limit=#{limit}&offset=#{offset}&api_key=#{api_key}&business=#{business}")) }

      it { expect(Phonify.subscriptions(limit: limit, offset: offset)[:subscriptions]).to match_array(subscriptions) }
    end

    describe '#unsubscribe' do
      let(:action) { 'post_form' }
      let(:response) { double(code: '200', body: { result: 'OK' }.to_json) } 

      before { Net::HTTP.should_receive(action).with(URI("https://www.phonify.io/v1/subscriptions/#{id}/unsubscribe"), business: business, api_key: api_key) }

      it { expect(Phonify.unsubscribe(id)[:result]).to eq('OK') }
    end
  end
end