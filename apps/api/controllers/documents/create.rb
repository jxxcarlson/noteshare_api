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

      if @access.valid
        CreateDocument.new(params, @access.user_id).call
      else
        deny_access
      end

    end

    def verify_csrf_token?
      false
    end

  end
end

