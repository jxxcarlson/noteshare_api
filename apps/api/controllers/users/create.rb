module Api::Controllers::Users
  class Create
    include Api::Action

    def call(params)
      result = CreateUser.new(params).call

      # self.body = "username = #{params['username']}, password = #{params['password']}, password_confirmation = #{params['password_confirmation']}, email = #{params['email']} "
      if result.err
        error = result.err[1]
      else
        error = 'None'
      end
      self.body = { status: result.status, error: error }.to_json

    end
  end
end
