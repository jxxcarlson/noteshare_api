require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'

include Permission

module Api::Controllers::Documents
  class Create
    include Api::Action



    def create_document(query_string)
      puts "***** Create document with query string: #{query_string}"
      document = NSDocument.new(params)
      document.owner_id = @access.user_id
      document.author_name = @access.username


      created_document = DocumentRepository.create document

      command, arg = query_string.split('=')
      if command == 'append' && arg
        parent_document = DocumentRepository.find arg
        if parent_document
          parent_document.append_to_documents_link arg
        end
      end

      if created_document
        # response.status = 200
        hash = {'status' => 'success', 'document' => created_document.to_hash }
        puts "Created document with hash = #{hash}"
        self.body = hash.to_json
      else
        self.body = '{ "error" => "500 Server error: document not created" }'
      end
    end


    def call(params)

      puts "request.query_string: #{request.query_string}"
      query_string =  request.query_string || ""

      puts "query_string: #{query_string}"

      verify(params)

      if @access.valid
        create_document(query_string)
      else
        deny_access
      end

    end


    def verify_csrf_token?
      false
    end

  end
end

