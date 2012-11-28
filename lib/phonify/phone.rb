class Phonify::Phone < ActiveRecord::Base
  REMOTE_ATTRS = [:number, :country, :carrier, :description, :created_at]
  QUERY_ATTRS = [:campaign_id, :number, :country, :carrier, :offset, :limit]
  include Phonify::Base
end

