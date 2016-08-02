module Api::Controllers::Images
  class Create
    include Api::Action

    def call(params)
      message = "Image controller, url: #{params[:url]}"
      puts message
      image = Image.new(url: params[:url], content_type: params[:content_type], title: params['title'])
      image = ImageRepository.create(image)
     self.body = { 'title': image.title, 'id': image.id, 'url': image.url, 'content_type': image.content_type}.to_json
    end
  end
end
