class UserRepository
  include Hanami::Repository

  def self.find_by_username(username)
    query do
      where(username: username)
    end.first
  end

end
