require 'spec_helper'

describe Phonify::Base do
  describe Phonify::Phone do
    let(:phonify_phone_attrs) { {number: "8888", country: "es", campaign_id: "007", description: "Lorem ipsum", created_at: 1.day.ago.to_i} }
    before(:each) do
      @api = mock "Phonify::Api"
      @api.stub!(:phone).and_return(phonify_phone_attrs)
      @api.stub!(:phones).and_return([])
      @api.stub!(:create_phone) {|params| phonify_phone_attrs.merge(params)}
      Phonify::Api.stub!(:instance).and_return(@api)
    end
    describe 'remote attributes' do
      let(:phone) { Phonify::Phone.find( FactoryGirl.create(:phone, phonify_phone_attrs).id ) }
      it 'should be populated via api when any remote attribute was accessed' do
        phone.remote_attributes.should == {}
        attr_name = Phonify::Phone::REMOTE_ATTRS.sample
        phone.send(attr_name).should == phonify_phone_attrs[attr_name]
        phone.remote_attributes.should == phonify_phone_attrs
      end
    end

    context '#belongs_to :owner' do
      before(:each) do
        Object.send :remove_const, :Phone if defined?(Phone)
        Object.send :remove_const, :User if defined?(User)
      end
      context 'User has_one :phone' do
        before(:each) do
          class Phone < Phonify::Phone; end
          class User < ActiveRecord::Base
            has_one :phone, as: :owner
          end
        end
        it 'should work' do
          u = User.new
          u.build_phone
          u.phone.token = 'ABC'
          u.save!
          u.reload.phone.token.should == 'ABC'
        end
      end
      context 'User has_many :phones' do
        before(:each) do
          class Phone < Phonify::Phone; end
          class User < ActiveRecord::Base
            has_many :phones, as: :owner
          end
        end
        it 'should work' do
          u = User.new
          u.phones.build(token: 'ABC')
          u.save!
          u.reload.phones.last.token.should == 'ABC'
        end
      end
    end
  end

  describe Phonify::Message do
    let(:phonify_message_attrs) { {
      id: "message123",
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
      created_at: 1.day.ago.to_i,
      schedule: 1.day.since.to_i,
    } }
    before(:each) do
      @api = mock "Phonify::Api"
      @api.stub!(:message).and_return(phonify_message_attrs)
      @api.stub!(:messages).and_return([])
      @api.stub!(:create_message) {|params| phonify_message_attrs.merge(params)}
      Phonify::Api.stub!(:instance).and_return(@api)
    end
    describe 'remote attributes' do
      let(:message) { Phonify::Message.find( FactoryGirl.create(:message, phonify_message_attrs).id ) }
      it 'should be populated via api when any remote attribute was accessed' do
        message.remote_attributes.should == {}
        attr_name = Phonify::Message::REMOTE_ATTRS.sample
        message.send(attr_name).should == phonify_message_attrs[attr_name]
        message.remote_attributes.should == phonify_message_attrs
      end
    end
  end

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
      created_at: 1.day.ago.to_i,
    } }
    before(:each) do
      @api = mock "Phonify::Api"
      @api.stub!(:subscription).and_return(phonify_subscription_attrs)
      @api.stub!(:subscriptions).and_return([])
      @api.stub!(:create_subscription) {|params| phonify_subscription_attrs.merge(params)}
      Phonify::Api.stub!(:instance).and_return(@api)
    end
    describe 'remote attributes' do
      let(:subscription) { Phonify::Subscription.find( FactoryGirl.create(:subscription, phonify_subscription_attrs).id ) }
      it 'should be populated via api when any remote attribute was accessed' do
        subscription.remote_attributes.should == {}
        attr_name = Phonify::Subscription::REMOTE_ATTRS.sample
        subscription.send(attr_name).should == phonify_subscription_attrs[attr_name]
        subscription.remote_attributes.should == phonify_subscription_attrs
      end
    end

    context '#belongs_to :owner' do
      before(:each) do
        Object.send :remove_const, :Subscription if defined?(Subscription)
        Object.send :remove_const, :User if defined?(User)
      end
      context 'User has_one :subscription' do
        before(:each) do
          class Subscription < Phonify::Subscription; end
          class User < ActiveRecord::Base
            has_one :subscription, as: :owner
          end
        end
        it 'should work' do
          u = User.new
          u.build_subscription
          u.subscription.token = 'ABC'
          u.save!
          u.reload.subscription.token.should == 'ABC'
        end
      end
      context 'User has_many :subscriptions' do
        before(:each) do
          class Subscription < Phonify::Subscription; end
          class User < ActiveRecord::Base
            has_many :subscriptions, as: :owner
          end
        end
        it 'should work' do
          u = User.new
          u.subscriptions.build(token: 'ABC')
          u.save!
          u.reload.subscriptions.last.token.should == 'ABC'
        end
      end
    end
  end
end
