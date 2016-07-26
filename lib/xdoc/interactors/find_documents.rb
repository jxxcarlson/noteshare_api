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

  def query_to_hash(query)
    elements = query.split('&')
    hash = {}
    elements.each do |element|
      key, value = element.split('=')
      hash[key] = value
    end
    hash
  end

  def all_documents
    @documents = DocumentRepository.all
  end

  def public_documents
    @documents = DocumentRepository.find_public
  end

  def user_documents(username)
    user = UserRepository.find_by_username(username)
    @documents = DocumentRepository.find_by_owner(user.id)
  end

  def document_hash(document)
    { :id => document.id, :title => document.title, :url => "/documents/#{document.id}"}
  end

  def call
    puts "QUERY STRING: #{@query_string}"
    terms = query_to_hash @query_string
    scope_terms = terms['scope'].split('.')
    scope = scope_terms[0]
    puts "Scope terms: #{scope_terms}"
    case scope
      when 'all'
        puts "Searching for all documents ..."
        all_documents
      when 'public'
        puts "Searching for public documents ..."
        public_documents
      when 'user'
        user_documents(scope_terms[1])
      else
        all_documents
    end
    @document_count = @documents.count
    @document_hash_array = @documents.map { |document| document_hash(document) }
  end
end

