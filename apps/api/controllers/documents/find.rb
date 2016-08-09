
require_relative '../../../../lib/xdoc/interactors/find_documents'

module Api::Controllers::Documents
  class Find
    include Api::Action

    def call(params)
      puts "Search controller: #{request.query_string}"
      result = FindDocuments.new(request.query_string).call
      puts "Number of documents: #{result.document_hash_array.count}"
      puts "Hash array:"
      result.document_hash_array.each do |item|
        puts item
      end

      self.body = { :status => 200, :document_count => result.document_count, :documents => result.document_hash_array }.to_json

    end


    def verify_csrf_token?
      false
    end

  end
end
