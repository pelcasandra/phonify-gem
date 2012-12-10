require 'ostruct'

module Phonify
  def self.config
    @config ||= OpenStruct.new
  end

  class Exception < ::Exception; end
end

require 'phonify/base'
require 'phonify/phone'
require 'phonify/subscription'
require 'phonify/message'
