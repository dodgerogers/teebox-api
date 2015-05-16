class CreateUserSession
  include Interactor
  
  INVALID_ATTRS = 'Invalid email or password.'
  NOT_FOUND = "Could not find user with username: %s"
  
  def call
    username = context[:username]
    password = context[:password]
    
    repo = UserRepository.new
    result = repo.find_by username: username
    
    if result.success?
      user = result.entity
      if user.valid_password? password
        user.reset_auth_token! if user.invalid_token?
        context.user = user
      else
        context.fail! message: INVALID_ATTRS, status: 401
      end
    else
      context.fail! message: NOT_FOUND % username, status: 404
    end
  end
end