class Phonify::Phone < ActiveRecord::Base
  REMOTE_ATTRS = [:number, :country, :campaign_id, :description, :created_at]
  include Phonify::Base
end

