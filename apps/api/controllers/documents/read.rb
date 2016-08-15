require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'

include Permission

module Api::Controllers::Documents
  class Read
    include Api::Action

    def get_document(document)
      if document
        # response.status = 200
        hash = {'status' => 'success', 'document' => document.hash }
        self.body = hash.to_json
      else
        # response.status = 500
        self.body = { "error" => "500 Server error: document not found or processed" }.to_json
      end
    end

    def call(params)

      id = params['id']
      puts "API: read id = #{id}"


      if id =~ /\A[1-9][0-9]*\z/
        puts "  -- FIND numerical id"
        document = DocumentRepository.find(id)
      else
        puts "  -- FIND identifier"
        document = DocumentRepository.find_by_identifier(id)
        puts "  -- document:"
        puts "  -- id: #{document.id}"
        puts "  -- title: #{document.title}"
      end


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
