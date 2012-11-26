require 'active_record'
require 'phonify/api'

module Phonify::Base
  def self.included(base)
    base.table_name = base.name.gsub(/\W+/, '_').tableize

    base.send(:attr_accessor, :remote_attributes)
    base.after_initialize do |object|
      object.remote_attributes = {}
    end

    base.send(:attr_accessor, *base::REMOTE_ATTRS)
    base::REMOTE_ATTRS.each do |attr_name|
      base.send(:define_method, attr_name) do
        self.remote_attributes = self.api.send(self.class.api_name, self.token) if self.remote_attributes.blank? && self.token.present?
        self.remote_attributes[attr_name]
      end
    end

    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    def api_name
      self.name.split(':').last.downcase
    end
    def api
      Phonify::Api.instance
    end
  end

  def api
    Phonify::Api.instance
  end
end
