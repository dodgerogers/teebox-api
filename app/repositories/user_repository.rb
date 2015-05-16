class UserRepository
  include Teebox::ActiveRecordAbstractions
  include Teebox::Repository

  declare User
  
  NOT_FOUND = "User with ID: %s not found"
  
  def initialize(user=nil)
    @user = user
  end
  
  def find_all_by_rank
    users = where_not user, rank: 0
    users = order users, :rank
    
    self.collection = users
    self
  end
  
  private 
  
  def find_by_id(params)
    user_id = params.fetch :id
    users = where user, id: user_id
    
    self.fail message: NOT_FOUND % user_id unless users.any?
    self.entity = users.first
    return self
  end
  
  def find_by_username(params)
    username = params.fetch :username
    users = where user, username: username
    
    self.fail message: NOT_FOUND % username unless users.any?
    self.entity = users.first
    return self
  end
end