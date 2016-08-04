require 'hanami/interactor'


# The FindDocument interactor authenticates
#
# Search language -- query elements
#
# scope=all
# scope=public
# scope=user.baz # return records for user baz
#
# title=mech   # Return 'Quantum Mechanics' and 'mechanical toys'
#
# To do
# #####
#
# Query elements should be composable without regard to order, e.g.
#
# scope=public&title=mech&tag=atom&title=electro
#
# In this example, the public records with tag=atom
# and title containing both 'mech' and 'electro', with
# the search being case insensitive
#
class FindDocuments
  include Hanami::Interactor

  expose :documents, :document_count, :document_hash_array

  def initialize(query_string, conditions)
    @query_string = query_string
    @conditions = conditions
    @status = 400
  end

  def query_to_hash(query)
    query ||= ''
    elements = query.split('&')
    hash = {}
    elements.each do |element|
      key, value = element.split('=')
      hash[key] = value
    end
    puts "hash: #{hash}"
    hash
  end

  def all_documents
    puts "Getting all documents ..."
    @documents = DocumentRepository.all
  end

  def public_documents
    puts "Getting public documents ..."
    @documents = DocumentRepository.find_public
  end

  def user_documents(username)
    puts "Getting user documents ..."
    user = UserRepository.find_by_username(username)
    @documents = DocumentRepository.find_by_owner(user.id)
  end

  def document_hash(document)
    { :id => document.id, :title => document.title, :url => "/documents/#{document.id}", :public => document.public}
  end

  def search_by_scope
    scope_terms = @search_hash['scope'].split('.')
    scope = scope_terms[0]
    puts "Scope terms: #{scope_terms}"
    case scope
      when 'all'
        all_documents
      when 'public'
        public_documents
      when 'user'
        if @search_hash['title']
          user = UserRepository.find_by_username(scope_terms[1])
          @documents = DocumentRepository.find_by_owner_and_fuzzy_title(user.id, @search_hash['title'])
        else
          user_documents(scope_terms[1])
        end
      else
        all_documents
    end
  end

  def call
    @search_hash = query_to_hash @query_string
    @conditions_hash = query_to_hash @conditions
    if @search_hash['scope']
      search_by_scope
    elsif @search_hash['title']
      @documents = DocumentRepository.fuzzy_find_by_title(@search_hash['title'])
    end
    if @documents
      @document_count = @documents.count
      @document_hash_array = @documents.map { |document| document_hash(document) }
    else
      @document_hash_array = []
    end

    case @conditions_hash['filter']
      when 'public'
          puts "Filtering for public documents"
          @document_hash_array = @document_hash_array.select{ |item| item[:public] }
      else
        puts "No filtering"
    end

  end
end

