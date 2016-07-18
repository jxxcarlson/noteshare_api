
require_relative '../../../../lib/xdoc/interactors/access_token'

module Api::Controllers::Users
  class Gettoken
    include Api::Action


    def call(params)
      puts "ID: #{params[:id]}"
      puts "QUERY STRING: #{request.query_string}"
      result = AccessToken.new(username: params[:id], password: request.query_string).call

      # self.body = "Status: #{result.status}, ID: #{params[:id]}, QUERY STRING: #{request.query_string}"
      self.body = "Status: #{result.status}, token: #{result.token}"
    end
  end
end
