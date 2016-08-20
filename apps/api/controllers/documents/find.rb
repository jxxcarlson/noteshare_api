
require_relative '../../../../lib/xdoc/interactors/find_documents'
require_relative '../../../../lib/xdoc/interactors/grant_access'
require_relative '../../../../lib/xdoc/modules/verify'

include Permission

module Api::Controllers::Documents
  class Find
    include Api::Action

    def search


    end

    def call(_params)
      puts "API: find"

      ## Get access token from request headers and compute @access
      token = request.env["HTTP_ACCESSTOKEN"]
      @access = GrantAccess.new(token).call

      search_result = FindDocuments.new(request.query_string, @access).call

      self.body = { :status => 'success', :document_count => search_result.document_count, :documents => search_result.document_hash_array }.to_json
    end


    def verify_csrf_token?
      false
    end

  end
end
