
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
      puts " -- params['author_name']: #{params['author_name']}"
      puts " -- params['document id']: #{params['id']}"



      verify_request(request)

      document = DocumentRepository.find params['id']
      author = UserRepository.find_by_username @access.username

      puts "-- access username: #{@access.username}"
      puts "-- access valid: #{@access.valid}"


      if @access.valid  && author.id == document.owner_id
        puts "Access valid"
        delete_document(params)
      else
        puts "Access denied"
        self.body = error_document_response('Sorry, you do not have access to that document')
      end

    end

    def verify_csrf_token?
      false
    end


  end
end
