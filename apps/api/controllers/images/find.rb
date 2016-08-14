require_relative '../../../../lib/xdoc/interactors/find_documents'

module Api::Controllers::Images
  class Find
    include Api::Action

    def call(params)
      puts "API, IMAGE, FIND"
      puts "Search controller: #{request.query_string}"

      token = request.env["HTTP_ACCESSTOKEN"]
      @access = GrantAccess.new(token).call


      result = FindImages.new(request.query_string, @access).call
      # response.status = 200
      self.body = { :status => 'success', :image_count => result.image_count, :images => result.image_hash_array }.to_json

    end

    def verify_csrf_token?
      false
    end

  end
end
