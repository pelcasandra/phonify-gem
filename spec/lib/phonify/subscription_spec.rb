require 'spec_helper'

describe Phonify::Subscription do
  let(:phonify_subscription_attrs) { {
    origin: {
      id: "abc",
      number: "111",
      country: "es",
      carrier: "movistar",
    },
    service: {
      id: "xyz",
      number: "999",
      country: "us",
      carrier: "att",
    },
    campaign_id: "camp1",
    active: true,
    description: "Lorem ipsum",
    created_at: 1.day.ago,
  } }
  before(:each) do
    @api = mock "Phonify::Api"
    @api.stub!(:subscription).and_return(phonify_subscription_attrs)
    Phonify::Api.stub!(:new).and_return(@api)
  end
end
