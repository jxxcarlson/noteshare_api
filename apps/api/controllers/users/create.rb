
require_relative '../../../../lib/xdoc/interactors/grant_access'

module Api::Controllers::Users
  class Create
    include Api::Action

    def call(params)
      result = CreateUser.new(params).call

      # self.body = "username = #{params['username']}, password = #{params['password']}, password_confirmation = #{params['password_confirmation']}, email = #{params['email']} "
      if result.err
        error = result.err[1]
        self.body = { :status => result.status, :error => error }.to_json
      else
        error = 'None'
        access= AccessToken.new(username: params[:username], password: params[:password]).call
        self.body = { :status => result.status, :error => error, :token => access.token }.to_json
      end

    end
  end
end
