

module Api::Controllers::Images
  class Get
    include Api::Action

    def image_hash(image)
      { :id => image.id, :title => image.title, :storage_url => image.url,
        :url => "/images/#{image.id}", :content_type => image.content_type }
    end

    def call(params)
      id = params['id']
      image = ImageRepository.find(id)
      if image
        # response.status = 200
        hash = {'response' => 'success', 'image' => image_hash(image) }
        self.body = hash.to_json
      else
        # response.status = 500
        self.body = { "error" => "500 Server error: document not found or processed" }.to_json
      end
    end
  end
end
