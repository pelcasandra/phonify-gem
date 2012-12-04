require 'spec_helper'

describe Phonify::Message do
  let(:phonify_message_attrs) {
    { :id => "msg123",
      :message => "hello world",
      :campaign_id => "camp123",
      :origin => { :number => "123", :country => "es", :carrier => "movistar" },
      :destination => { :number => "567", :country => "es", :carrier => "movistar" },
      :delivered => true,
      :amount => 10,
      :currency => "USD",
      :description => "Lorem ipsum",
      :created_at => 1.day.ago.to_i,
      :schedule => 1.day.since.to_i,
    }
  }
  before(:each) do
    @api = mock "Phonify::Api"
    Phonify::Api.stub!(:instance).and_return(@api)
  end
  describe '#broadcast' do
    it 'should work' do
      attrs = { :message => "this is sms", :campaign_id => "camp-#{rand(100)}", :schedule => 3.days.since.to_i }
      @api.should_receive(:broadcast).with(attrs)
      Phonify::Message.broadcast(attrs[:campaign_id], attrs[:message], attrs[:schedule])
    end
  end
  describe '#create' do
    it 'should store "token=message.id" from existing remote record' do
      attrs = phonify_message_attrs.except(:id, :created_at)
      params = { :message => attrs[:message],
                 :sender => attrs[:origin],
                 :receiver => [attrs[:destination]],
                 :campaign_id => attrs[:campaign_id],
                 :schedule => attrs[:schedule],
               }
      @api.should_receive(:create_message).with(params).and_return(phonify_message_attrs)
      message = Phonify::Message.create(attrs)
      message.reload.token.should == phonify_message_attrs[:id]
    end
  end
end
