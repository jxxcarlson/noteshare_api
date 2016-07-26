module Api::Controllers::Images
  class Get
    include Api::Action

    def call(params)
      id = params['id']
      image = ImageRepository.find(id)
      if image
        hash = {'response' => '202 Accepted', 'image' => image.to_h}
        self.body = hash.to_json
      else
        self.body = '{ "response" => "500 Server error: document not found or processed" }'
      end
    end
  end
end
