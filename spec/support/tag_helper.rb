require "spec_helper"

module TagHelper
  def tag_list
    list = []
    list << @tag1 = create(:tag, name: "chunk")
    list << @tag2 = create(:tag, name: "driver")
    list << @tag3 = create(:tag, name: "putter")
    list << @tag4 = create(:tag, name: "hook")
    list << @tag5 = create(:tag, name: "shank")
    list << @tag6 = create(:tag, name: "fat")
  end
end