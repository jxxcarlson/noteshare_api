require 'hanami/interactor'


# The FindDocument interactor authenticates
#
# Search language -- query elements
#
# A query is of the form TERM, TERM&TERM, etc.
# A TERM is of the form COMMAND=ARG
#
# EXAMPLES:
#
#     scope=all
#     scope=public
#     user=baz
#     title=mech
#     tag=physics
#     user.title=baz.mech  -- return user baz's files which contain 'mech' in the title
#                          -- search is case insensitive
#     user.public=baz      -- return articles that are public or belong to baz
#
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

  def initialize(query_string, access)
    @query_string = query_string.downcase
    @access = access
    @documents = []
    @status = 400
  end

  def parse
    @queries = @query_string.split('&').map{ |item| item.split('=')}
    puts "1. @queries: #{@queries}"
  end

  ######## SEARCH ########

  def all_documents
    puts "Getting all documents ..."
    @documents = DocumentRepository.all
  end

  def public_documents
    puts "Getting public documents ..."
    @documents = DocumentRepository.find_public
  end

  def user_search(username)
    puts "Getting user documents ..."
    user = UserRepository.find_by_username(username)
    @documents = DocumentRepository.find_by_owner(user.id)
  end

  def scope_search(arg)
    case arg
      when 'all'
        all_documents
      when 'public'
        public_documents
      else
        all_documents
    end
  end

  def user_title_search(arg)
    username, title = arg.split('.')
    user = UserRepository.find_by_username(username)
    @documents = DocumentRepository.find_by_owner_and_fuzzy_title(user.id, title)
  end

  def user_public_search(arg)
    username, title = arg.split('.')
    user = UserRepository.find_by_username(username)
    @documents = DocumentRepository.find_public_by_owner(user.id)
  end

  def title_search(arg)
    @documents = DocumentRepository.fuzzy_find_by_title(arg)
    puts "@documents.class = #{@documents.class.name}"
  end

  def id_search(arg)
    puts "id_search with argument #{arg}"
    @documents = [DocumentRepository.find(arg)]
  end

  def tag_search(arg)
    @documents = DocumentRepository.find_by_tag(arg)
  end

  def search(query)
    puts "query: #{query}"
    command, arg = query
    case command
      when 'scope'
        scope_search(arg)
      when 'user'
        user_search(arg)
      when 'title'
        title_search(arg)
      when 'user.title'
        user_title_search(arg)
      when 'user.public'
        user_public_search(arg)
      when 'id'
        id_search(arg)
      when 'tag'
        tag_search(arg)
    end
    @document_hash_array = @documents.map { |document| document.short_hash }
    puts "After SEARCH, @document_hash_array.count = #{@document_hash_array.count}"
  end

  ######## FILTER ########

  def user_filter(owner_id)
    lambda{ |dochash| dochash[:owner_id] == owner_id }
  end

  def user_or_public_filter(owner_id)
    lambda{ |dochash| ( (dochash[:public] == true) || (dochash[:owner_id] == owner_id) ) }
  end

  def public_filter
    lambda{ |dochash| dochash[:public]  == true }
  end

  def title_filter(arg)
    lambda{ |dochash| dochash[:title].downcase =~ /#{arg}/ }
  end

  def user_id(key)
    if key =~ /[0-9].*/
      key
    else
      user = UserRepository.find_by_username key
      user.id
    end
  end


  def apply_filter(query, hash_array)
    puts "QUERY: #{query}"
    puts "BEFORE: applying filter #{query} to hash_array (#{hash_array.count})"
    # puts "HASH ARRAY BEFORE:"
    # hash_array.each { |item| puts item }
    command, arg = query
    puts "command: #{command}"
    puts "arg: #{arg}"

    case command
      when 'scope'
        case arg
          when 'public'
            puts "APPLYING PUBLIC FILTER"
            hash_array = hash_array.select(&public_filter)
          else
        end
      when 'user'
        id = user_id(arg)
        hash_array = hash_array.select(&user_filter(id))
      when 'user.public'
        id = user_id(arg)
        hash_array = hash_array.select(&user_or_public_filter(id))
      when 'title'
        hash_array = hash_array.select(&title_filter(arg))
    end
    # puts "AFTER: applying filter #{query} to hash_array (#{hash_array.count})"
    # puts "HASH ARRAY AFTER:"
    # hash_array.each { |item| puts item }
    hash_array
  end

  def filter_hash_array
    puts "FILTER, queries = #{@queries}"
    @queries.each do |query|
      @document_hash_array = apply_filter(query, @document_hash_array)
    end
  end

  def set_id_array
    @id_array = @document_hash_array.map{ |hash| hash[:id] }
  end

  def filter_documents
    set_id_array
    if @documents.class.name == 'Array'
      @documents = @documents.select{ |doc| @id_array.include?(doc.id) }
    else
      @documents = @documents.all.select{ |doc| @id_array.include?(doc.id) }
    end
    # puts "@documents.count = #{@documents.count}"
  end

  def apply_permissions
    if @access == nil || @access.username == nil
      @queries << ["scope", "public"]
    else
      @queries << ["user.public", @access.username]
    end
  end

  def normalize

  end

  ######## CALL ########

  def call
    puts "************ ENTER FIND DOCUMENTS ************"
    parse
    apply_permissions
    puts "2. @queries: #{@queries}"
    normalize
    puts "@queries: #{@queries}"
    query = @queries.shift
    search(query)
    filter_hash_array
    filter_documents
    if @documents == []
      puts "No documents found"
      puts "ENV['DEFAULT_DOCUMENT_ID'] = #{ENV['DEFAULT_DOCUMENT_ID']}"
      default_document = DocumentRepository.find(ENV['DEFAULT_DOCUMENT_ID'])
      puts "default_document: #{default_document.title} (#{default_document.id})"
      @documents = [default_document]
      @document_hash_array = @documents.map { |document| document.short_hash }
      # puts "After adjustment, @document_hash_array = #{@document_hash_array}"
    end
    @document_count = @documents.count
    puts "************ EXT FIND DOCUMENTS ************"
  end
end

