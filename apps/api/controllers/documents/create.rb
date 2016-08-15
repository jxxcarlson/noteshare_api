require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'

include Permission

module Api::Controllers::Documents
  class Create
    include Api::Action



    def create_document(query_string)
      document = NSDocument.new(params)
      document.owner_id = @access.user_id
      document.author_name = @access.username


      created_document = DocumentRepository.create document

      command, arg = query_string.split('=')
      if command == 'append' && arg
        parent_document = DocumentRepository.find arg
        puts "APPEND TO: #{parent_document.title}"
        document_list = parent_document.links['documents'] || []
        puts "Parent document list: #{document_list}"
        document_list << created_document.short_hash
        parent_document.links['documents'] = document_list
        DocumentRepository.update parent_document
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

