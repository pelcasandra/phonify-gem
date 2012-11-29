require 'ostruct'

class Phonify::Campaign
  def self.config
    @config ||= OpenStruct.new
  end
end
