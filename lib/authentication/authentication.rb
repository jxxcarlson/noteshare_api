# lib/authentication/authentication.rb
# @api auth
# Authentication base class
#
# Based on code by @theCrab
#
# See: https://gist.github.com/theCrab/54a339b7a08ddad84e35
#      https://github.com/theCrab/hanami-fumikiri
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