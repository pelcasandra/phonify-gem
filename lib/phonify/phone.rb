class Phonify::Phone < ActiveRecord::Base
  REMOTE_ATTRS = [:number, :country, :carrier, :description, :created_at]
  QUERY_ATTRS = [:campaign_id, :number, :country, :carrier, :offset, :limit]
  include Phonify::Base

  def messages(scope = Phonify::Message)
    return Phonify::Message.where(:phone_id => self.id) if scope == :local
    Phonify::Message::Collection.new(scope.where(:phone_id => self.id), :destination => { :id => self.token }, :campaign_id => self.campaign_id)
  end

end

