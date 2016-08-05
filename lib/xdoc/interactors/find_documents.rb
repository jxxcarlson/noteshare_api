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

  def query_to_hash_array(query)
    query ||= ''
    elements = query.split('&')
    array = []
    elements.each do |element|
      key, value = element.split('=')
      hash = { key => value}
      array.push(hash)
    end
    puts "array: #{array}"
    array
  end

  def user_filter(owner_id)
    lambda{ |dochash| dochash['owner_id'] == owner_id }
  end

  def user_or_public_filter(owner_id)
    lambda{ |dochash| dochash['public'] || (dochash['owner_id'] == owner_id) }
  end

  def public_filter
    lambda{ |dochash| dochash[:public]  == true }
  end

  def filters
    { 'public': public_filter}
  end

  def prepare_filters(hash)
    hash.select{ |h| h.keys[0] == 'filter'}.map{|h| h['filter']}.map{ |item| item.split('.')}
  end

  def apply_filter(filter, hash_array)
    puts "BEFORE: applying filter #{filter} to hash_array (#{hash_array.count})"
    case filter[0]
      when 'public'
        hash_array = hash_array.select(&public_filter)
      when 'user'
        username = filter[1]
        user = UserRepository.find_by_username username
        hash_array = hash_array.select(&user_filter(user.id))
      when 'user_or_public'
        username = filter[1]
        user = UserRepository.find_by_username username
        hash_array = hash_array.select(&user_or_public_filter(user.id))
    end
    puts "AFTER: applying filter #{filter} to hash_array (#{hash_array.count})"
    hash_array
  end

  def execute_filters(filter_array, hash_array)
    filter_array.each do |filter|
      hash_array = apply_filter(filter, hash_array)
    end
    hash_array
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
    { :id => document.id, :title => document.title, :url => "/documents/#{document.id}",
      :public => document.public, owner_id: document.owner_id }
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
    @conditions_hash_array = query_to_hash_array @conditions
    if @search_hash['scope']
      search_by_scope
    elsif @search_hash['title']
      @documents = DocumentRepository.fuzzy_find_by_title(@search_hash['title'])
    end
    if @documents
      @document_count = @documents.count
      @document_hash_array = @documents.map { |document| document_hash(document) }
    else
      @document_count = 0
      @document_hash_array = []
    end


    filter_array = prepare_filters @conditions_hash_array
    @document_hash_array = execute_filters filter_array, @document_hash_array

    id_array = @document_hash_array.map{ |item| item[:id]}
    puts "id_array: #{id_array}"
    @documents = @documents.select{ |doc|  id_array.include? doc.id}


  end
end

