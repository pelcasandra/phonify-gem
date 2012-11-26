require 'spec_helper'

describe Phonify::Message do
  before(:each) do
    @api = mock "Phonify::Api"
    Phonify::Api.stub!(:instance).and_return(@api)
  end
  describe '#broadcast' do
    it 'should work' do
      attrs = { message: "this is sms", campaign_id: "camp-#{rand(100)}", schedule: 3.days.since.to_i }
      @api.should_receive(:broadcast).with(attrs)
      Phonify::Message.broadcast(attrs[:campaign_id], attrs[:message], attrs[:schedule])
    end
  end
end
