require 'hanami/interactor'

require 'jwt'


# The GrantAccess interactor authenticates
# a user who presents a valid access token
#
# References:
#
#   https://github.com/jwt/ruby-jwt
#   http://restcookbook.com/Basics/loggingin/
#
# The access token carries an encrypted
# version of
#
#    payload = { :username => @username, :password => password }
#
# GrantAccess decodes the payload
# and returns result.valid = true if and only if  the password
# is valid for the given user.
#
class GrantAccess
  include Hanami::Interactor

  expose :valid, :status, :username, :user_id

  def initialize(token)
    @token = token
    @status = 401
    @valid = false
  end

  def call
    # Reference: http://rubylearning.com/satishtalim/ruby_exceptions.html
    begin
      decoded_token = JWT.decode @token, ENV['HMAC_SECRET'], true, { :algorithm => 'HS256' }
    rescue
      return
    end
    @status = 200
    payload = decoded_token[0]
    @username = payload['usr']
    password = payload['pwd']
    user = UserRepository.find_by_username(@username)
    @user_id = user.id
    @valid = (BCrypt::Password.new(user.password_hash) == password)
  end
end

