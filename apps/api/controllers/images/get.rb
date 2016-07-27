module Api::Controllers::Images
  class Get
    include Api::Action

    def image_hash(image)
      { :id => image.id, :title => image.title, :storage_url => image.url, :url => "/images/#{image.id}" }
    end

    def call(params)
      id = params['id']
      image = ImageRepository.find(id)
      if image
        hash = {'response' => '202 Accepted', 'image' => image_hash(image) }
        self.body = hash.to_json
      else
        self.body = '{ "response" => "500 Server error: document not found or processed" }'
      end
    end
  end
end
