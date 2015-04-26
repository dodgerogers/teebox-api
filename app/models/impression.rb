class Impression < ActiveRecord::Base
  #attr_accessible :ip_address
  belongs_to :impressionable, polymorphic: true, counter_cache: true
  validates_uniqueness_of :ip_address, scope: :impressionable_id
end