class ActivityRepository < BaseRepository
  declare Activity
  
  NOT_FOUND = "Activity with ID: %s not found"
  
  def initialize(user)
    @user = user
  end
  
  def find_all
    activities = where activity, recipient_id: @user.id
    activities = order activities, :created_at

    self.collection = activities
    self
  end
  
  def find_and_update(params)
    result = find_by_id params.slice :id
    activity = result.entity
    
    activity.assign_attributes params
    self.fail message: error_messages(activity) unless save(activity)
    
    self.entity = activity
    return self
  end
  
  private 
  
  def find_by_id(params)
    activity_id = params.fetch :id
    activities = where activity, id: activity_id
    
    self.fail message: NOT_FOUND % activity_id unless activities.any?
    self.entity = activities.first
    return self
  end
end