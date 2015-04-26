class Playlist < ActiveRecord::Base
  belongs_to :question
  belongs_to :video
end