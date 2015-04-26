require "spec_helper"

module VideoHelper
  def video_list
    list = []
    4.times do
      list << create(:video)
    end
    list
  end
end