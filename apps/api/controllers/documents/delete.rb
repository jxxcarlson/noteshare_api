
require_relative '../../../../lib/xdoc/modules/verify'

module Api::Controllers::Documents
  class Delete
    include Api::Action

    include Permission

    def delete_document(params)
      id = params['id']
      document = DocumentRepository.find(id)

      if document && document.owner_id == @access.user_id
        DocumentRepository.delete document
        puts "Document #{id} deleted"
        reply =  { 'status': 'success','info': "document{#id} deleted" }
      else
        # response.status = 500
        self.body = { "error" => "500 Server error: document not found or processed or permissions invalid" }.to_json
      end
      self.body = reply.to_json
    end

    def call(params)

      puts "API DELETE"
      puts " -- token: params["

      verify_request(request)

      puts "-- access username:u #{@access.username}"
      puts "-- access valid: #{@access.valid}"

      if @access.valid  && @access.username == params['author_name']
        puts "Access valid"
        delete_document(params)
      else
        puts "Access denied"
        self.body = error_document_response
      end

    end

    def verify_csrf_token?
      false
    end


  end
end
