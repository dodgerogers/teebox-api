module Teebox::Toggle
  extend ActiveSupport::Concern
  
  def toggle_correct(attribute)
    toggle(attribute).update_attributes({attribute => self[attribute]})
  end
end