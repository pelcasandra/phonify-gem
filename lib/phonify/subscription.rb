class Phonify::Subscription < ActiveRecord::Base
  REMOTE_ATTRS = [:origin, :service, :description, :created_at]
  QUERY_ATTRS = [:campaign_id, :origin, :service, :active, :offset, :limit]
  include Phonify::Base

  belongs_to :phone, :class_name => Phonify::Phone

  before_create :find_or_create_token_by_remote_object
  def find_or_create_token_by_remote_object
    create_attributes = self.remote_attributes.except(:active).merge(:id => self.token, :campaign_id => self.campaign_id).reject {|k,v| v.blank?}
    query_attributes = create_attributes.slice(*self.class::QUERY_ATTRS)
    if self.remote_attributes = (self.api.send(self.api_name.pluralize, query_attributes).first || self.api.send("create_#{self.api_name}", create_attributes).first)
      self.token = self.remote_attributes[:id]
      self.active = self.remote_attributes[:active]
      self.phone = Phonify::Phone.where(:campaign_id => self.campaign_id, :token => self.remote_attributes[:origin][:id]).first ||
                   self.create_phone(self.remote_attributes[:origin].except(:id).merge({
                     :token => self.remote_attributes[:origin][:id],
                     :campaign_id => self.campaign_id,
                     :owner_id => self.owner_id,
                     :owner_type => self.owner_type,
                   }))
    else
      self.errors.add(:service, "not found")
    end
  end

  def confirm!(pin)
    self.remote_attributes = self.api.send("confirm_#{self.api_name}", self.token, :pin => pin)
    self.active = self.remote_attributes[:active]
    self.save!
  end

  def cancel!
    if self.api.send("cancel_#{self.api_name}", self.token).try(:[], :active) == false
      self.destroy
    end
  end

  def messages(scope = Phonify::Message)
    return Phonify::Message.where(:subscription_id => self.id) if scope == :local
    self.phone.messages(scope.where(:subscription_id => self.id))
  end

end
