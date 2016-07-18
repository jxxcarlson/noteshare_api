module Api::Controllers::Documents
  class Read
    include Api::Action

    def call(params)
      id = params['id']
      document = DocumentRepository.find(id)
      if document
        hash = {'response' => '202 Accepted', 'document' => document.to_hash }
        self.body = hash.to_json
      else
        self.body = '{ "response" => "500 Server error: document not found or processed" }'
      end
    end


    def verify_csrf_token?
      false
    end

  end
end
