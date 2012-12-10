class Phonify::Message < ActiveRecord::Base
  REMOTE_ATTRS = [:message, :origin, :destination, :delivered, :amount, :currency, :description, :created_at, :schedule]
  QUERY_ATTRS = [:campaign_id, :message, :origin, :destination, :sent, :offset, :limit]
  include Phonify::Base
  def self.broadcast(campaign_id, message, schedule = nil)
    api.broadcast(:campaign_id => campaign_id, :message => message, :schedule => schedule)
  end

  before_create :find_or_create_token_by_remote_object, :unless => :token?
  def find_or_create_token_by_remote_object
    create_attributes = { :message => self.remote_attributes[:message],
                          :origin => self.remote_attributes[:origin],
                          :destination => [self.remote_attributes[:destination]],
                          :campaign_id => self.campaign_id,
                          :schedule => self.remote_attributes[:schedule],
                        }
    self.remote_attributes = self.api.send("create_#{self.api_name}", create_attributes)
    self.token = self.remote_attributes[:id]
  end

  belongs_to :subscription, :class_name => Phonify::Subscription
  belongs_to :phone, :class_name => Phonify::Phone

  class Collection
    def initialize(scope, params)
      @scope = scope
      @params = params
    end
    def where(params)
      @params.merge!(params)
      self
    end
    def find_or_create_from(remote_object)
      if record = @scope.where(:token => remote_object[:id], :campaign_id => remote_object[:campaign_id]).first
        #
      else record = @scope.new(:token => remote_object[:id], :campaign_id => remote_object[:campaign_id])
        record.remote_attributes = remote_object
        record.save!
      end
      record
    end
    def create(attrs)
      create_params = @params.merge(attrs)
      create_params = create_params[:destination].present? ? create_params.merge(destination: [create_params[:destination]]) : create_params
      remote_objects = Phonify::Message.api.create_message(create_params)
      remote_objects.collect do |remote_object|
        find_or_create_from remote_object
      end
    end
    def method_missing(sym, *args)
      array = Phonify::Message.api.messages(@params).collect do |remote_object|
        find_or_create_from remote_object
      end
      array.send(sym, *args)
    end
  end

end
