require_relative '../../../../lib/xdoc/modules/verify'
require_relative '../../../../lib/xdoc/interactors/grant_access'

module Api::Controllers::Images
  class Create
    include Api::Action
    include Permission

    def create_image
      message = "Image controller, owner = #{params[:owner]}, url: #{params[:url]}"
      puts message
      url = "http://psurl.s3.amazonaws.com/#{params[:filename]}"
      user = UserRepository.find_by_username(params[:owner])
      image = Image.new(url: url, title: params[:title],
                        content_type: params[:content_type],  owner_id: user.id)
      image = ImageRepository.create(image)
      # response.status = 200
      self.body = { 'status': 'success', 'title': image.title, 'id': image.id, 'url': image.url, 'content_type': image.content_type}.to_json
    end

    def call(params)

      token = request.env["HTTP_ACCESSTOKEN"]
      @access = GrantAccess.new(token).call

      if @access.valid
        create_image
      else
        deny_access
      end


    end
  end
end
