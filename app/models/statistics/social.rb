require "open-uri"
require "json"

class Statistics::Social < ActiveRecord::Base
  #attr_accessible :likes, :followers
  validates_presence_of :likes, :followers
  include Teebox::Sociable
  
  def generate
    self.class.transaction do
      self.likes = JSON.parse(open("http://graph.facebook.com/TeeboxNetwork?fields=likes").read)["likes"]
      self.followers = Teebox::Sociable.client.user.followers_count
    end
  end
end