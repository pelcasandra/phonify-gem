class Phonify::Message < ActiveRecord::Base
  REMOTE_ATTRS = [:message, :origin, :destination, :campaign_id, :delivered, :amount, :currency, :description, :created_at]
  include Phonify::Base
end
