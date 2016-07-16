module Api::Controllers::Documents
  class Delete
    include Api::Action

    def call(params)
      puts "API: delete document  "
      puts "API: delete document #{params['id']}"
      id = params['id']
      document = DocumentRepository.find(id)

      if document
        puts "Document #{id} found"
      end

      if document
        DocumentRepository.delete document
        self.body = "{ 'response' => '200 success: document{#id} deleted'"
      else
        self.body = '{ "response" => "500 Server error: document not found or processed" }'
      end

    end

    def verify_csrf_token?
      false
    end


  end
end
