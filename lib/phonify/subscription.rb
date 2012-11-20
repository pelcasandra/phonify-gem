class Phonify::Subscription < ActiveRecord::Base
  REMOTE_ATTRS = [:origin, :service, :campaign_id, :active, :description, :created_at]
  include Phonify::Base
end
