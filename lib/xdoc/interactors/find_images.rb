require 'hanami/interactor'


# The Findimage interactor authenticates
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
class FindImages

  include Hanami::Interactor

  expose :images, :image_count, :image_hash_array

  def initialize(query_string, access)
    @query_string = query_string.downcase
    @access = access
    @images = []
    @status = 400
  end

  def parse
    @queries = @query_string.split('&').map{ |item| item.split('=')}
    puts "1. @queries: #{@queries}"
  end

  def image_hash(image)
    { :id => image.id, :title => image.title, :storage_url => image.url, :url => "/images/#{image.id}" }
  end


  ######## SEARCH ########

  def all_images
    puts "Getting all images ..."
    @images = ImageRepository.all
  end

  def public_images
    puts "Getting public images ..."
    @images = ImageRepository.find_public
  end

  def user_search(username)
    puts "Getting user images ..."
    user = UserRepository.find_by_username(username)
    @images = ImageRepository.find_by_owner(user.id)
  end

  def scope_search(arg)
    case arg
      when 'all'
        all_images
      when 'public'
        public_images
      else
        all_images
    end
  end

  def user_title_search(arg)
    username, title = arg.split('.')
    user = UserRepository.find_by_username(username)
    @images = ImageRepository.find_by_owner_and_fuzzy_title(user.id, title)
  end

  def user_public_search(arg)
    username, title = arg.split('.')
    user = UserRepository.find_by_username(username)
    @images = ImageRepository.find_public_by_owner(user.id)
  end

  def title_search(arg)
    @images = ImageRepository.fuzzy_find_by_title(arg)
    puts "@images.class = #{@images.class.name}"
  end

  def id_search(arg)
    puts "id_search with argument #{arg}"
    @images = [ImageRepository.find(arg)]
  end

  def random_search(percentage)
    puts "*** Random search"
    @images = ImageRepository.random_sample(percentage)[0..10]
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
      when 'random'
        random_search(arg)
      when 'id'
        id_search(arg)
    end
    @image_hash_array = @images.map { |image| image_hash(image) }
    puts "After SEARCH, @image_hash_array.count = #{@image_hash_array.count}"
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
    # puts "BEFORE: applying filter #{query} to hash_array (#{hash_array.count})"
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
    puts "AFTER: applying filter #{query} to hash_array (#{hash_array.count})"
    # puts "HASH ARRAY AFTER:"
    # hash_array.each { |item| puts item }
    hash_array
  end

  def filter_hash_array
    puts "FILTER, queries = #{@queries}"
    @queries.each do |query|
      @image_hash_array = apply_filter(query, @image_hash_array)
    end
  end

  def set_id_array
    @id_array = @image_hash_array.map{ |hash| hash[:id] }
  end

  def filter_images
    set_id_array
    if @images.class.name == 'Array'
      @images = @images.select{ |doc| @id_array.include?(doc.id) }
    else
      @images = @images.all.select{ |doc| @id_array.include?(doc.id) }
    end
    # puts "@images.count = #{@images.count}"
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
    parse
    # apply_permissions
    puts "2. @queries: #{@queries}"
    normalize
    puts "@queries: #{@queries}"
    query = @queries.shift
    search(query)
    filter_hash_array
    filter_images
    if @images == []
      puts "No images found"
      puts "ENV['DEFAULT_IMAGE_ID'] = #{ENV['DEFAULT_IMAGE_ID']}"
      default_image = ImageRepository.find(ENV['DEFAULT_IMAGE_ID'])
      puts "default_image: #{default_image.title} (#{default_image.id})"
      @images = [default_image]
      @image_hash_array = @images.map { |image| image_hash(image) }
      puts "After adjustment, @image_hash_array = #{@image_hash_array}"
    end
    @image_count = @images.count
  end
end

