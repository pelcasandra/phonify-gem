require 'spec_helper'

describe Phonify::Message do
  let(:phonify_message_attrs) { {
    message: "hello",
    origin: {
      id: "abc",
      number: "111",
      country: "es",
      carrier: "movistar",
    },
    destination: {
      id: "xyz",
      number: "999",
      country: "us",
      carrier: "att",
    },
    campaign_id: "camp1",
    delivered: true,
    amount: "0",
    currency: "USD",
    description: "Lorem ipsum",
    created_at: 1.day.ago,
  } }
  before(:each) do
    @api = mock "Phonify::Api"
    @api.stub!(:message).and_return(phonify_message_attrs)
    Phonify::Api.stub!(:new).and_return(@api)
  end
end
