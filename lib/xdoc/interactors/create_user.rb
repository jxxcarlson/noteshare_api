
require 'hanami/interactor'


# Create shoobox for user with title = user.screen_name
# and attach it to the user
class CreateUser
  include Hanami::Interactor

  expose :err, :status, :username, :email, :user

  def initialize(hash)
    @username = hash[:username]
    @password = hash[:password]
    @password_confirmation = hash[:password_confirmation]
    @email = hash[:email]
    # @err = [ENV['ERRCODE_OK', 'OK']]
    @err = nil
    @OK = "0"
  end


  def verify_password
    if @password != @password_confirmation
      @err = [ENV['ERRCODE_PASSWORD_MISSMATCH'], "Passwords don't match"]
      @status = 400
      return
    end

    if @password.length < 8
      @err = [ENV['ERRCODE_PASSWORD_TOO_SHORT'], "Password must be at least eight characters"]
      @status = 400
    end
  end

  def verify_username
    if !(@username =~ /[a-z][a-z0-9]*\z/)
      @err = [ENV['ERRCODE_BAD_USERNAME'], "Bad user name"]
      @status = 400
      return
    end

    user = UserRepository.find_by_username(@username)
    if user
      @err = [ENV['ERRCODE_USER_ALREADY_EXISTS'], "That user name is already taken"]
      @status = 400
    end
  end

  def verify_email
    if @email == nil
      @err = [ENV['ERRCODE_EMAIL_MISSING'], "You must provide an email address"]
      @status = 400
      return
    end

    if !(@email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      # Reference: http://emailregex.com/
      @err = [ENV['ERRCODE_EMAIL_INVALID'], "The email address you provided is invalid"]
      @status = 400
    end
  end


  def call
    verify_username
    return if @err
    verify_password
    return if @err
    verify_email
    return if @err
    user = User.new(username: @username, email: @email)
    user.password_hash =  BCrypt::Password.create(@password)
    @user =  UserRepository.create user
    @status = 200 if @user
  end

end





