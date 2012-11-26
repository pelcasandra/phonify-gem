class Phonify::Subscription < ActiveRecord::Base
  REMOTE_ATTRS = [:origin, :service, :active, :description, :created_at]
  include Phonify::Base
end
