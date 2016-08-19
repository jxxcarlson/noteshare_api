require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'
require_relative '../../../../lib/xdoc/interactors/create_document'

include Permission

module Api::Controllers::Documents
  class Create
    include Api::Action

    def call(params)

      query_string =  request.query_string || ""

      puts "API: new document"
      puts "options: #{params['options']}"
      puts "current_document_id: #{params['current_document_id']}"
      puts "parent_document_id: #{params['parent_document_id']}"
      puts "request.query_string: #{query_string}"


      verify(params)

      def foo
        if created_document
        # response.status = 200
        hash = {'status' => 'success', 'document' => created_document.to_hash }
        puts "Created document with hash = #{hash}"
        self.body = hash.to_json
        else
          self.body = '{ "error" => "500 Server error: document not created" }'
        end
      end

      if @access.valid
        result = CreateDocument.new(params, @access.user_id).call
        if result.status == 'success'
          hash = {'status' => 'success', 'document' => result.new_document.to_hash }
          puts "Created document with hash = #{hash}"
          self.body = hash.to_json
        else
          self.body = '{ "error" => "500 Server error: document not created" }'
        end
      else
        deny_access
      end

    end

    def verify_csrf_token?
      false
    end

  end
end

