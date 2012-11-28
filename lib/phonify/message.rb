class Phonify::Message < ActiveRecord::Base
  REMOTE_ATTRS = [:message, :origin, :destination, :delivered, :amount, :currency, :description, :created_at, :schedule]
  QUERY_ATTRS = [:campaign_id, :message, :origin, :destination, :sent, :offset, :limit]
  include Phonify::Base
  def self.broadcast(campaign_id, message, schedule = nil)
    api.broadcast(campaign_id: campaign_id, message: message, schedule: schedule)
  end

  before_create :find_or_create_token_by_remote_object
  def find_or_create_token_by_remote_object
    create_attributes = { message: self.remote_attributes[:message],
                          sender: self.remote_attributes[:origin],
                          receiver: [self.remote_attributes[:destination]],
                          campaign_id: self.campaign_id,
                          schedule: self.remote_attributes[:schedule],
                        }
    self.remote_attributes = self.api.send("create_#{self.api_name}", create_attributes)
    self.token = self.remote_attributes[:id]
  end
end
