require_relative '../../../../lib/xdoc/interactors/grant_access'

=begin
module Api::Controllers::Documents
  class Create
    include Api::Action

    def call(params)
      token = params['token']
      puts "TOKEN: #{token}"

      result = GrantAccess(token).call
      if result.valid == false
        self.body = { "error" => "401 Access denied" }.to_json
        return
      end
      params['user_id'] = result.user_id

      document = NSDocument.new(params)
      created_document = DocumentRepository.create document
      if created_document
        hash = {'response' => '202 Created', 'document' => created_document.to_hash }
        self.body = hash.to_json
      else
        self.body = { "error" => "500 Could not create document" }.to_json
      end
    end


    def verify_csrf_token?
      false
    end

  end
end
=end


module Api::Controllers::Documents
  class Create
    include Api::Action

    def call(params)
      token = params['token']
      puts "TOKEN: #{token}"
      result = GrantAccess.new(token).call
      puts "result.valid = #{result.valid}"
      puts "result.user_id = #{result.user_id}"
      puts "result.username = #{result.username}"

      if result.valid == false
        self.body = { "error" => "401 Access denied" }.to_json
        return
      end

      document = NSDocument.new(params)
      document.owner_id = result.user_id
      created_document = DocumentRepository.create document
      if created_document
        hash = {'response' => '202 Created', 'document' => created_document.to_hash }
        self.body = hash.to_json
      else
        self.body = '{ "response" => "500 Server error: document not created" }'
      end
    end


    def verify_csrf_token?
      false
    end

  end
end

