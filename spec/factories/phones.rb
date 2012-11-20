FactoryGirl.define do
  factory :phone, :class => Phonify::Phone do
    sequence(:token) {|n| '%07d' % n }
  end
end
