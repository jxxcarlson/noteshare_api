require 'hanami/interactor'


# The Findimage interactor authenticates

#
class FindImages
  include Hanami::Interactor

  expose :images, :image_count, :image_hash_array

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

  def all_images
    @images = ImageRepository.all
  end

  def public_images
    @images = ImageRepository.find_public
  end

  def user_images(username)
    user = UserRepository.find_by_username(username)
    @images = ImageRepository.find_by_owner(user.id)
  end

  def image_hash(image)
    { :id => image.id, :title => image.title, :storage_url => image.url, :url => "/images/#{image.id}" }
  end

  def call
    puts "QUERY STRING: #{@query_string}"
    terms = query_to_hash @query_string
    scope_terms = terms['scope'].split('.')
    scope = scope_terms[0]
    puts "Scope terms: #{scope_terms}"
    case scope
      when 'all'
        puts "Searching for all imges ..."
        all_images
      when 'public'
        puts "Searching for public images ..."
        public_images
      when 'user'
        user_images(scope_terms[1])
      else
        all_images
    end
    @image_count = @images.count
    @image_hash_array = @images.map { |image| image_hash(image) }
  end
end

