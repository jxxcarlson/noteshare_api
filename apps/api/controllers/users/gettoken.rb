
require_relative '../../../../lib/xdoc/interactors/access_token'

module Api::Controllers::Users
  class Gettoken
    include Api::Action


    def call(params)
      result = AccessToken.new(username: params[:id], password: request.query_string).call
      self.body = {:status => result.status, :token => result.token }.to_json
    end
  end
end
