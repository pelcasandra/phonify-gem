FactoryGirl.define do
  factory :message, :class => Phonify::Message do
    sequence(:token) {|n| '%07d' % n }
  end
end
