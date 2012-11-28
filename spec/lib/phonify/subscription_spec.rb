require 'spec_helper'

describe Phonify::Subscription do
  let(:phonify_subscription_attrs) { {
    id: "sub123",
    origin: { id: "abc", number: "111", country: "es", carrier: "movistar" },
    service: { id: "xyz", number: "999", country: "us", carrier: "att" },
    campaign_id: "camp1",
    active: false,
    description: "Lorem ipsum",
    created_at: 1.day.ago.to_i,
  } }
  let(:origin_phone_attr) { phonify_subscription_attrs[:origin] }
  let(:create_attrs) { phonify_subscription_attrs.except(:id, :active, :created_at).merge({
    origin: origin_phone_attr.except(:id),
    service: phonify_subscription_attrs[:service].except(:id),
  }) }
  let(:query_params) { {
    origin: create_attrs[:origin],
    service: create_attrs[:service],
    campaign_id: create_attrs[:campaign_id],
  } }
  before(:each) do
    @api = mock "Phonify::Api"
    @api.stub!(:subscription).and_return(phonify_subscription_attrs)
    Phonify::Api.stub!(:instance).and_return(@api)
  end
  describe '#create' do
    it 'should store "token=subscription.id" from existing remote record' do
      @api.should_receive(:subscriptions).with(query_params).and_return([phonify_subscription_attrs])
      subscription = Phonify::Subscription.create(create_attrs)
      subscription.reload.token.should == phonify_subscription_attrs[:id]
      subscription.reload.active.should == phonify_subscription_attrs[:active]
    end
    it 'should create remote record if none exist' do
      @api.should_receive(:subscriptions).with(query_params).and_return([])
      @api.should_receive(:create_subscription).with(create_attrs).and_return(phonify_subscription_attrs)
      subscription = Phonify::Subscription.create(create_attrs)
      subscription.reload.token.should == phonify_subscription_attrs[:id]
      subscription.reload.active.should == phonify_subscription_attrs[:active]
    end
    it 'should create local phone record' do
      @api.should_receive(:subscriptions).with(query_params).and_return([])
      @api.should_receive(:create_subscription).with(create_attrs).and_return(phonify_subscription_attrs)
      lambda {
        @subscription = Phonify::Subscription.create(create_attrs)
      }.should change(Phonify::Phone, :count)
      @subscription.reload.phone.should == (phone = Phonify::Phone.first)
      @api.should_receive(:phone).with(phone.token).and_return(origin_phone_attr)
      phone.number.should == origin_phone_attr[:number]
    end
    it 'should associate local phone record if exist' do
      @api.should_receive(:subscriptions).with(query_params).and_return([])
      @api.should_receive(:create_subscription).with(create_attrs).and_return(phonify_subscription_attrs)
      old_phone = FactoryGirl.create(:phone, origin_phone_attr.merge({
        campaign_id: phonify_subscription_attrs[:campaign_id],
        token: origin_phone_attr[:id],
        id: nil
      }))
      lambda {
        @subscription = Phonify::Subscription.create(create_attrs)
      }.should_not change(Phonify::Phone, :count)
      @subscription.reload.phone.should == old_phone
    end
  end
  context 'with subscription' do
    before(:each) do
      @api.should_receive(:subscriptions).with(query_params).and_return([])
      @api.should_receive(:create_subscription).with(create_attrs).and_return(phonify_subscription_attrs)
      @subscription = Phonify::Subscription.create(create_attrs)
    end
    describe '#confirm!' do
      it 'should send pin to api & update local :active' do
        @subscription.reload.active.should == false
        some_pin = "#{'%03d' % rand(999)}"
        rand_active = [true,false].sample
        @api.should_receive(:confirm_subscription).with(@subscription.token, pin: some_pin).and_return(phonify_subscription_attrs.merge(active: rand_active))
        @subscription.confirm!(some_pin)
        @subscription.reload.active.should == rand_active
      end
    end
    describe '#cancel!' do
      it 'should inform api and remove local record' do
        @api.should_receive(:cancel_subscription).with(@subscription.token).and_return(phonify_subscription_attrs.merge(active: false))
        @subscription.cancel!
        lambda {
          @subscription.reload
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
