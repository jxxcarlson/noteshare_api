module Api::Controllers::Images
  class Create
    include Api::Action

    def call(params)
      message = "Image controller, owner = #{params[:owner]}, url: #{params[:url]}"
      puts message
      url = "http://psurl.s3.amazonaws.com/#{params[:filename]}"
      user = UserRepository.find_by_username(params[:owner])
      image = Image.new(url: url, title: params[:title],
                        content_type: params[:content_type],  owner_id: user.id)
      image = ImageRepository.create(image)
     self.body = { 'title': image.title, 'id': image.id, 'url': image.url, 'content_type': image.content_type}.to_json
    end
  end
end
