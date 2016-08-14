module Web::Controllers::Sessions
  class Create
    include Web::Action
    accept :json

    params do
      param :username, type: String, presence: true
      param :password, type: String, presence: true
    end

    def call(params)
      halt 422 unless params.valid?
      login
    end

    def login
      user = UserRepository.find_by_username(params[:username])
      halt 401 unless user
      halt 403 unless valid_password?(user.password_hash)

      options = { iss: 'http://hanamirb.org/', exp: 804700, user_id: user.id, audience: 'github' }
      token = JWT.encode(options, HANAMI_ENV['HMAC_SECRET'], algorithm: 'HS256')
      # response.status = 200
      self.body = { status: 'success', access_token: token}.to_json
    end

    def authenticate!
      # Nothing to see here, move along.
    end

    private
    def valid_password?(password)
      BCrypt::Password.new(params[:password]) == password
    end
  end
end
