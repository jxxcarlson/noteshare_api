require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'

include Permission

module Api::Controllers::Documents
  class Read
    include Api::Action

    def get_document(document)
      if document
        hash = {'response' => '202 Accepted', 'document' => document.to_hash }
        self.body = hash.to_json
      else
        self.body = '{ "response" => "500 Server error: document not found or processed" }'
      end
    end

    def call(params)
      puts "API: read"

      id = params['id']
      document = DocumentRepository.find(id)

      token = request.env["HTTP_ACCESSTOKEN"]
      puts " -- TOKEN: #{token}"
      @access = GrantAccess.new(token).call
      puts " -- ACCESS: #{@access.inspect}"

      if @access.valid
        get_document(document)
      elsif document.public
        get_document(document)
      else
        self.body = error_document_response
      end




    end


    def verify_csrf_token?
      false
    end

  end
end
