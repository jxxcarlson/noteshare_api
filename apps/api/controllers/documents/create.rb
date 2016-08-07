require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'

include Permission

module Api::Controllers::Documents
  class Create
    include Api::Action



    def create_document
      document = NSDocument.new(params)
      document.owner_id = @result.user_id
      created_document = DocumentRepository.create document
      if created_document
        hash = {'status' => '202', 'document' => created_document.to_hash }
        puts "Created document with hash = #{hash}"
        self.body = hash.to_json
      else
        self.body = '{ "error" => "500 Server error: document not created" }'
      end
    end


    def call(params)

      verify(params)

      if @result.valid
        create_document
      else
        deny_access
      end

    end


    def verify_csrf_token?
      false
    end

  end
end

