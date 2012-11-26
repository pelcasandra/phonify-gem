class Phonify::Message < ActiveRecord::Base
  REMOTE_ATTRS = [:message, :origin, :destination, :campaign_id, :delivered, :amount, :currency, :description, :created_at]
  include Phonify::Base
  def self.broadcast(campaign_id, message, schedule = nil)
    api.broadcast(campaign_id: campaign_id, message: message, schedule: schedule)
  end
end
