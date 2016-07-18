
require 'hanami/interactor'


# Create shoobox for user with title = user.screen_name
# and attach it to the user
class NewUser
  include Hanami::Interactor

  expose :err, :username, :email, :user

  def initialize(hash)
    @username = hash[:username]
    @password = hash[:password]
    @password_confirmation = hash[:password_confirmation]
    @email = hash[:email]
    # @err = [ENV['ERRCODE_OK', 'OK']]
    @err = [ENV['ERRCODE_OK'], 'OK']
    @OK = "0"
  end

  def verify_password
    @err = [ENV['ERRCODE_PASSWORD_MISSMATCH'], "Passwords don't match"] if @password != @password_confirmation
    return if @err[0] != @OK

    @err = [ENV['ERRCODE_PASSWORD_TOO_SHORT'], "Password must be at least eight characters"] if @password.length < 8

    puts "ERR: #{@err}"
    return if @err[0] != @OK
  end


  def call
    verify_password
    return if @err[0] != @OK
    user = User.new(username: @username, email: @email)
    user.password_hash =  BCrypt::Password.create(@password)
    @user =  UserRepository.create user
  end

end





