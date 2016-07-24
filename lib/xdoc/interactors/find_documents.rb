require 'hanami/interactor'


# The FindDocument interactor authenticates

#
class FindDocuments
  include Hanami::Interactor

  expose :documents, :document_count, :document_hash_array

  def initialize(query_string)
    @query_string = query_string
    @status = 400
  end

  def all_documents
    @documents = DocumentRepository.all
  end

  def document_hash(document)
    { :id => document.id, :title => document.title, :url => "/documents/#{document.id}"}
  end

  def call
    case @query_string
      when 'all'
        all_documents
      else
        all_documents
    end
    @document_count = @documents.count
    @document_hash_array = @documents.map { |document| document_hash(document) }
  end
end

