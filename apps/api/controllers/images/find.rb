require_relative '../../../../lib/xdoc/interactors/find_documents'
require_relative '../../../../lib/xdoc/modules/verify'
require_relative '../../../../lib/xdoc/interactors/grant_access'

module Api::Controllers::Images
  class Find
    include Api::Action
    include Permission

    def find_images
      result = FindImages.new(request.query_string, @access).call
      # response.status = 200
      self.body = { :status => 'success', :image_count => result.image_count, :images => result.image_hash_array }.to_json
    end

    def call(params)
      puts "API, IMAGE, FIND"
      puts "Search controller: #{request.query_string}"

      token = request.env["HTTP_ACCESSTOKEN"]
      puts "TOKEN: #{token}"
      @access = GrantAccess.new(token).call

      if @access.valid
        find_images
      else
        deny_access
      end


    end

    def verify_csrf_token?
      false
    end

  end
end
