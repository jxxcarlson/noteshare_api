
require 'hanami/interactor'

require 'jwt'


# The AccessToken interactor authenticates
# a user.  If authenticated, it returns
# a packet which includes a JWT token which
# grants access to the system as well as
# @status and @response_body for a JSON reply
# to a request for access
#
# Reference:
#
#   https://github.com/jwt/ruby-jwt
#   http://restcookbook.com/Basics/loggingin/
#
# The access token carries an encrypted
# version of
#
#    payload = { :username => @username, :password => password }
#
# Thus, when the system reeeives a token, it can decrypt the payload
# and verify that the password is valid for the given user, at which
# point access can be granted. See the interactor GrantAccess
#
class AccessToken
  include Hanami::Interactor

  expose :err, :token, :status, :response_body

  def initialize(hash)
    @username = hash[:username]
    @password = hash[:password]
    @status = 401
  end


  def call
    @user = UserRepository.find_by_username(@username)
    @err = [ENV['ERRCODE_USER_NOT_FOUND'], "User not found by that name"] if @user == nil
    return if @err

    @err = [ENV['ERRCODE_INVALID_PASSWORD'], "Invalid password"] if valid_password? == false
    return if @err

    # options = { iss: 'http://hanamirb.org/', exp: 804700, user_id: @user.id, audience: 'github' }
    payload = { :usr => @username, :pwd => @password }
    hmac_secret = ENV['HMAC_SECRET']
    algorithm = 'HS256'
    @token = JWT.encode(payload, hmac_secret, algorithm)
    @status = 200
    @response_body = { access_token: @token}.to_json
  end

  private
  def valid_password?
    BCrypt::Password.new(@user.password_hash) == @password
  end

end





