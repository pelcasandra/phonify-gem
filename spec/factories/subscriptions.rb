FactoryGirl.define do
  factory :subscription, :class => Phonify::Subscription do
    sequence(:token) {|n| '%07d' % n }
  end
end
