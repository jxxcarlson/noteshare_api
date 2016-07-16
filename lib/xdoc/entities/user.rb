class User
  include Hanami::Entity

  attributes :user_name, :admin, :status, :email, :password,
             :created_at, :updated_at, :dict, :links
end
