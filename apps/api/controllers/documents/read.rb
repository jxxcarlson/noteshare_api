require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'

include Permission

module Api::Controllers::Documents
  class Read
    include Api::Action

    def return_document(document)
      if document
        hash = {'status' => 'success', 'document' => document.hash }
        self.body = hash.to_json
      else
        self.body = { "error" => "500 Server error: document not found or processed" }.to_json
      end
    end

    def  get_document(id)
      puts "API: read id = #{id}"
      if id =~ /\A[1-9][0-9]*\z/
        document = DocumentRepository.find(id)
      else
        document = DocumentRepository.find_by_identifier(id)
      end
      if document
        if document.has_subdocuments
          document.update_document_links
        end
      end
      document
    end

    def call(params)

      document = get_document(params['id'])

      token = request.env["HTTP_ACCESSTOKEN"]
      @access = GrantAccess.new(token).call

      if @access.valid
        return_document(document)
      elsif document.public
        return_document(document)
      else
        self.body = error_document_response
      end

    end


    def verify_csrf_token?
      false
    end

  end
end
