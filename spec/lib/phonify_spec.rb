require 'spec_helper'

describe Phonify do
  let(:app) { 'app' }
  let(:phone) { 'phone' }

  before do
    Phonify.token = 'token'
  end

  describe "#send_subscription_message" do
    let(:body) { 'body' }

    it "call post_form with the appropiate parameters" do
      response = mock(code: '200', body: { id: 10 }.to_json)
      Net::HTTP.stub('post_form').and_return(response)
      Net::HTTP.should_receive('post_form').with(URI('http://api.phonify.io/v1/subscriptions/messages'), app: app, phone: phone, body: body, token: 'token')
      Phonify.send_subscription_message(app, phone, body).should == 10
    end
  end

  describe "#subscription_active?" do
    it "call get_response with the appropriate parameters" do
      response = mock(code: '200', body: { active: true }.to_json)
      Net::HTTP.stub('get_response').and_return(response)
      Net::HTTP.should_receive('get_response').with(URI("http://api.phonify.io/v1/subscriptions/active?app=#{app}&phone=#{phone}&token=token"))
      Phonify.subscription_active?(app, phone).should == true
    end
  end

end
