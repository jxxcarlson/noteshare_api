
require_relative '../../../../lib/xdoc/interactors/find_documents'

module Api::Controllers::Documents
  class Find
    include Api::Action

    def call(params)

      result = FindDocuments.new(request.query_string).call
      self.body = { :status => 200, :document_count => result.document_count, :documents => result.document_hash_array }.to_json

    end


    def verify_csrf_token?
      false
    end

  end
end
