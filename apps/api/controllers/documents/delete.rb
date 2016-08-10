
require_relative '../../../../lib/xdoc/modules/verify'

module Api::Controllers::Documents
  class Delete
    include Api::Action

    include Permission

    def delete_document(params)
      id = params['id']
      document = DocumentRepository.find(id)

      if document
        DocumentRepository.delete document
        self.body = "{ 'response' => '200 success: document{#id} deleted'"
      else
        self.body = '{ "response" => "500 Server error: document not found or processed" }'
      end
    end

    def call(params)

      verify(params)

      if @access.valid
        delete_document(params)
      else
        deny_access
      end

    end

    def verify_csrf_token?
      false
    end


  end
end
