module Api::Controllers::Documents
  class Create
    include Api::Action

    def call(params)
      puts "API: creating document"
      document = NSDocument.new(params)
      created_document = DocumentRepository.create document
      if created_document
        hash = {'response' => '202 Created', 'document' => created_document.to_hash }
        self.body = hash.to_json
      else
        self.body = '{ "response" => "500 Server error: document not created" }'
      end
    end


    def verify_csrf_token?
      false
    end

  end
end
