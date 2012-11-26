class Phonify::Phone < ActiveRecord::Base
  REMOTE_ATTRS = [:number, :country, :description, :created_at]
  include Phonify::Base
end

