# lib/authentication/authentication.rb
# @api auth
# Authentication base class
#

module Authentication
  def self.included(base)
    base.class_eval do
      before :authenticate!
      expose :current_user
    end
  end

  def authenticate!
    halt 401 unless authenticated?
  end

  def current_user
    @current_user ||= authenticate_user
  end

  private
  def authenticated?
    !!current_user
  end

  def authenticate_user
    # Every api request has an access_token in the header
    # Find the user and verify they exist
    jwt = JWT.decode(payload, HANAMI_ENV['HMAC_SECRET'], algorithm: 'HS256')
    #user = User.with_token(headers['Authentication'])
    user = UserRepository.find(jwt.user_id)
    if user && !user.revoked
      return @current_user = user
    end
  end

end