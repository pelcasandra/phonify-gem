require 'spec_helper'

describe Phonify::Phone do
  let(:phonify_phone_attrs) { {id: "phone123", number: "8888", country: "es", campaign_id: "camp123", description: "Lorem ipsum", created_at: 1.day.ago.to_i} }
  before(:each) do
    @api = mock "Phonify::Api"
    @api.stub!(:phone).and_return(phonify_phone_attrs)
    Phonify::Api.stub!(:instance).and_return(@api)
  end
end
