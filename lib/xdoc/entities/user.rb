require 'bcrypt'

class User
  include Hanami::Entity

  attributes :username, :admin, :status,
             :email, :password_hash,
             :created_at, :updated_at,
             :dict, :links

  def initialize(hash)
    super
    self.dict  ||= {}
    self.links ||= {}
    self.admin ||= false
  end

  def change_password(new_password)
    self.password_hash = BCrypt::Password.create(new_password)
    # UserRepository.update self
  end

  def verify_password(password)
    return BCrypt::Password.new(self.password_hash) == password
  end


end
